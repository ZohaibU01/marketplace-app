import 'dart:convert';

import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/MVC/model/categoryModel.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    fetchAllCategories();
  }

  // Fetch all categories
  Future<void> fetchAllCategories() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('get-categories');
      if (response.statusCode == 200) {
        var decodedBody =  jsonDecode(response.body);
        final responseData = decodedBody['data']['data'] as List;
        categories.value = responseData
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to fetch categories.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Fetch categories by ID
  Future<List<CategoryModel>> fetchCategoriesById(int categoryId) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('/get-categories?category_id=$categoryId');
      if (response.statusCode == 200) {
        var decodedBody =  jsonDecode(response.body);
        final responseData = decodedBody['data']['data'] as List;
        return responseData
            .map((subcategory) => CategoryModel.fromJson(subcategory))
            .toList();
      } else {
        Get.snackbar("Error", "Failed to fetch categories by ID.");
        return [];
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return [];
    } finally {
      isLoading.value = false;
    }
  }
}
