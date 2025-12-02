import 'package:get/get.dart';
import 'dart:convert';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../model/productModel.dart';

class UserProductController extends GetxController {
  var isLoading = false.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> Myproducts = <ProductModel>[].obs;
  RxList<ProductModel> favoriteProducts = <ProductModel>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Future.wait(
        [
          fetchProducts(),
          fetchFavoriteProducts(),
        ]
    );
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.isEmpty) {
      return getAllProducts;
    }
    return getAllProducts.where((product) => product.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  List<ProductModel> get getAllProducts => products.where((p) => p.userId != DataStroge.currentUser.value?.id,).toList();

  List<ProductModel> getMyProducts(int userId)=> products.where((p) => p.userId == userId,).toList();

  int getTotalSales(int userId)=> getMyProducts(userId).where((p) => p.status == "sold out",).toList().length;
  int getTotalPurchases(int userId)=> products.where((p) => p.status == "sold out" && p.userId == userId,).toList().length;

  bool isInFavourite(int productId){
    return favoriteProducts.any((prod) => prod.id == productId,);
  }

  // Fetch products method
  Future<void> fetchProducts({
    int? id,
    int? limit,
    int? offset,
    String? customFields,
    int? categoryId,
    int? userId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? postedSince,
  }) async {
    isLoading.value = true;

    try {
      final queryParameters = {
        if (id != null) 'id': id.toString(),
        if (limit != null) 'limit': limit.toString(),
        if (offset != null) 'offset': offset.toString(),
        if (customFields != null) 'custom_fields': customFields,
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (userId != null) 'user_id': userId.toString(),
        if (minPrice != null) 'min_price': minPrice.toString(),
        if (maxPrice != null) 'max_price': maxPrice.toString(),
        if (sortBy != null) 'sort_by': sortBy,
        if (postedSince != null) 'posted_since': postedSince,
      };

      final queryString =
      queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');
      final response = await ApiService.get('get-item?$queryString');

      final responseData = jsonDecode(response.body);

      if (responseData['error'] == false) {
        final productData = responseData['data']['data'] as List;
        if(userId != null)
        {

        Myproducts.value =
            productData.map((item) => ProductModel.fromJson(item)).toList();
        }
        else{
          products.value =
            productData.map((item) => ProductModel.fromJson(item)).toList();
        }
      } else {
        Get.snackbar("Error", responseData['message']);
      }
    } catch (e,s) {
      print(e.toString() + s.toString());
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Fetch favorite products method
  Future<void> fetchFavoriteProducts() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('get-favourite-item',token: DataStroge.accesstoken.value);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['error'] == false) {
          final favoriteData = responseData['data']['data'] as List;
          favoriteProducts.value =
              favoriteData.map((item) => ProductModel.fromJson(item)).toList();
        } else {
          Get.snackbar("Error", responseData['message']);
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Error", "Failed to fetch favorite products.");
      }

    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // Add or remove favorite product method
  Future<void> addOrRemoveFavouriteProduct(int productId) async {
    // Store the current state to revert if needed
    final wasInFavourite = isInFavourite(productId);
    final originalProducts = List<ProductModel>.from(products);
    final originalFavorites = List<ProductModel>.from(favoriteProducts);
    
    // Optimistically update the UI
    if (wasInFavourite) {
      // Remove from favorites
      favoriteProducts.removeWhere((product) => product.id == productId);
      // Update the product in the main list to reflect the change
      final productIndex = products.indexWhere((product) => product.id == productId);
      if (productIndex != -1) {
        products[productIndex] = products[productIndex].copyWith(
          isLiked: false,
          likeCount: (products[productIndex].likeCount - 1).clamp(0, double.infinity).toInt(),
        );
      }
    } else {
      // Add to favorites
      final productToAdd = products.firstWhere((product) => product.id == productId);
      favoriteProducts.add(productToAdd);
      // Update the product in the main list to reflect the change
      final productIndex = products.indexWhere((product) => product.id == productId);
      if (productIndex != -1) {
        products[productIndex] = products[productIndex].copyWith(
          isLiked: true,
          likeCount: products[productIndex].likeCount + 1,
        );
      }
    }
    
    // Trigger UI update
    update();
    
    try {
      final response = await ApiService.post(
        'manage-favourite',
        data: {'item_id': productId.toString()},
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          // Success - no need to do anything as we already updated the UI
          // Get.snackbar("Success", responseData['message']);
        } else {
          // API returned an error, revert the changes
          _revertLikeChanges(originalProducts, originalFavorites);
          Get.snackbar("Error", responseData['message']);
        }
      } else {
        // HTTP error, revert the changes
        _revertLikeChanges(originalProducts, originalFavorites);
        Get.snackbar("Error", "Failed to update favorite product.");
      }
    } catch (e) {
      // Network or other error, revert the changes
      _revertLikeChanges(originalProducts, originalFavorites);
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Helper method to revert like changes
  void _revertLikeChanges(List<ProductModel> originalProducts, List<ProductModel> originalFavorites) {
    products.value = originalProducts;
    favoriteProducts.value = originalFavorites;
    update();
  }

  // Update product method
  Future<void> updateProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final response = await ApiService.post(
        'update-item',
        data: product.toJson(),
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          final updatedProduct = ProductModel.fromJson(responseData['data']);
          final index = products.indexWhere((item) => item.id == updatedProduct.id);
          if (index != -1) {
            products[index] = updatedProduct;
            update();
          }
          Get.snackbar("Success", responseData['message']);
        } else {
          Get.snackbar("Error", responseData['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to update product.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product method
  Future<void> deleteProduct(ProductModel product) async {
    try {
      isLoading.value = true;
      final response = await ApiService.post(
        'delete-item',
        data: {'id': product.id.toString()},
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          products.removeWhere((item) => item.id == product.id);
          update();
          Get.snackbar("Success", responseData['message']);
        } else {
          Get.snackbar("Error", responseData['message']);
        }
      }
      else {
        Get.snackbar("Error", "Failed to delete product.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // Checkout method
  Future<void> checkout({
    required int itemId,
    required double amount,
    required String currency,
    required String token,
    required int customerId,
    bool save = true,
  }) async {
    try {
      isLoading.value = true;

      final data = {
        'item_id': itemId.toString(),
        'amount': amount.toString(),
        'currency': currency,
        'token': token,
        // 'customer_id': customerId.toString(),
        'save': save ? "1" : "0",
      };

      final response = await ApiService.post(
        'checkout',
        data: data,
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          Get.snackbar("Success", responseData['message'] ?? "Checkout successful");
        } else {
          Get.snackbar("Error", responseData['message'] ?? "An error occurred during checkout");
        }
      } else {
        Get.snackbar("Error", "Failed to complete checkout: ${response.reasonPhrase}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
