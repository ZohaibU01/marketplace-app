import 'dart:convert';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toysell_app/MVC/model/categoryModel.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/popup_helper.dart';
import '../model/productModel.dart';
import '../view/sell/stripeWebViewScreen.dart';

class SellsController extends GetxController {
  // Controllers for form fields
  // Controllers
  final titleController = TextEditingController();
  final subCategoryController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

// Focus Nodes
  final titleFocus = FocusNode();
  final subCategoryFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final priceFocus = FocusNode();

  // Observables for managing images
  var images = <String>[].obs;
  var selectedSubCategory =
      Rx<CategoryModel?>(null); // Selected subcategory as CategoryModel
  var isLoading = false.obs; // To manage loading state

  @override
  void onInit() {
    super.onInit();
  }

  // @override
  // void dispose() {
  //   titleController.dispose();
  //   subCategoryController.dispose();
  //   descriptionController.dispose();
  //   priceController.dispose();

  //   titleFocus.dispose();
  //   subCategoryFocus.dispose();
  //   descriptionFocus.dispose();
  //   priceFocus.dispose();

  //   super.dispose();
  // }

  // Add image to the list
  void addImage(String imagePath) {
    images.add(imagePath);
  }

  // Remove image from the list
  void removeImage(String imagePath) {
    images.remove(imagePath);
  }

  // Validate the form fields
  String? validateTitle(String value) {
    if (value.isEmpty) {
      return "Title is required";
    }
    return null;
  }

  String? validateDescription(String value) {
    if (value.isEmpty) {
      return "Description is required";
    }
    return null;
  }

  String? validatePrice(String value) {
    if (value.isEmpty) {
      return "Price is required";
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return "Enter a valid price";
    }
    return null;
  }

  // Reset all form fields
  void resetForm() {
    titleController.clear();
    subCategoryController.clear();
    descriptionController.clear();
    priceController.clear();
    images.clear();
    selectedSubCategory.value = null;
  }

  // Post product to the server
  Future<ProductModel?> postProduct({
    required String address,
    required String contact,
    required double latitude,
    required double longitude,
    bool showOnlyToPremium = false,
    String? videoLink,
    required String country,
    required String state,
    required String city,
    required String slug,
    required String token,
    required BuildContext context,
  }) async {
    if (selectedSubCategory.value == null) {
      Get.snackbar("Error", "Please select a subcategory");
      return null;
    }

    if (images.isEmpty) {
      Get.snackbar("Error", "Please upload at least one image");
      return null;
    }

    isLoading.value = true;

    try {
      final data = {
        'name': titleController.text.trim(),
        'category_id': selectedSubCategory.value!.id.toString(),
        'price': priceController.text.trim(),
        'description': descriptionController.text.trim(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'address': address,
        'contact': contact,
        'show_only_to_premium': showOnlyToPremium ? "1" : "0",
        'video_link': videoLink ?? "",
        'country': country,
        'state': state,
        'city': city,
        'slug': slug,
      };

      var imageFiles = images.map((path) => File(path)).toList();

      // API call with stream response
      final streamedResponse = await ApiService.postMultiPart(
        'add-item',
        fields: data,
        files: imageFiles,
        fileFieldName: null,
        token: token,
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == true) {
          final message = responseData['message'] ?? "An error occurred";

          if (message.toString().toLowerCase().contains("stripe")) {
            PopupHelper.showPopup(
              context: context,
              title: "Stripe Connection Required",
              content: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  fontFamily: "Poppins",
                ),
              ),
              buttonText: "Connect Now",
              onButtonPressed: () {
                Get.back(); // close dialog
                connectStripeAccount();
              },
            );
          } else {
            Get.snackbar("Error", message);
          }

          return null;
        } else {
          final message = responseData['message'] ?? "";
          final link = responseData['data'];
          print(responseData);
          if (message.toLowerCase().contains("onboarding") &&
              link != null &&
              link.toString().startsWith("http")) {
            // Open onboarding in WebView
            Get.to(() => StripeWebViewScreen(url: link));
            // launchUrl(
            //   Uri.parse(link),
            //   mode: LaunchMode.externalApplication,
            // );
            return null;
          }

          // Normal success
          Get.snackbar("Success", "Product posted successfully");
          resetForm();
          return ProductModel.fromJson(responseData["data"][0]);
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to post the product: ${response.reasonPhrase}",
        );
        return null;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Update product
  Future<bool> updateProduct(ProductModel product) async {
    isLoading.value = true;

    try {
      final data = <String, dynamic>{
        'id': product.id.toString(),
        'name': titleController.text.trim(),
        'category_id': selectedSubCategory.value?.id.toString() ??
            product.category?.id.toString(),
        'price': priceController.text.trim(),
        'description': descriptionController.text.trim(),
        'latitude': product.latitude.toString(),
        'longitude': product.longitude.toString(),
        'address': product.address,
        'contact': product.contact,
        'show_only_to_premium': product.isPremium ? "1" : "0",
        'video_link': product.videoLink ?? "",
        'country': product.country,
        'state': product.state,
        'city': product.city,
        'slug': product.slug,
      };

      var localImagePaths = await processImages(images);
      var imageFiles = localImagePaths.map((path) => File(path)).toList();

      final streamedResponse = await ApiService.postMultiPart(
        'update-item',
        fields: data,
        files: imageFiles,
        fileFieldName: null,
        token: DataStroge.accesstoken.value,
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == true) {
          Get.snackbar("Error", responseData['message'] ?? "An error occurred");
          return false;
        } else {
          Get.snackbar("Success", "Product updated successfully");
          return true;
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to update the product: ${response.reasonPhrase}",
        );
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> processImages(List<String> images) async {
    // Filter local and network images
    var localImagePaths =
        images.where((path) => !path.startsWith('http')).toList();
    var networkImagePaths =
        images.where((path) => path.startsWith('http')).toList();

    // Download network images and get their local paths
    var downloadedFiles = await Future.wait(
      networkImagePaths.map((netImagePath) async {
        var file = await downloadAndSaveImage(netImagePath);
        return file?.path; // Returns local path if successful, null otherwise
      }),
    );

    // Remove null values (failed downloads)
    downloadedFiles.removeWhere((path) => path == null);

    // Add downloaded image paths to local images
    localImagePaths.addAll(downloadedFiles.cast<String>());

    return localImagePaths;
  }

  Future<File?> downloadAndSaveImage(String imageUrl) async {
    try {
      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Extract filename from URL
      final String fileName = imageUrl.split('/').last;
      final File file = File('${tempDir.path}/$fileName');

      // Check if file already exists
      if (await file.exists()) {
        return file;
      }

      // Download image
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Write the file to local storage
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null; // Return null if download fails
  }

  Future<void> connectStripeAccount() async {
    try {
      isLoading.value = true;
      final token = DataStroge.accesstoken.value;

      // Step 1: Generate Stripe Account ID
      final accResponse =
          await ApiService.get('generate-stripe-acc-id', token: token);
      final accJson = jsonDecode(accResponse.body);

      if (accResponse.statusCode != 200 ||
          accJson['error'] == true ||
          accJson['data'] == null) {
        Get.snackbar("Error",
            accJson['message'] ?? "Failed to create Stripe account ID");
        return;
      }

      final stripeAccountId = accJson['data'];

      // Step 2: Generate Onboarding Link
      final onboardResponse = await ApiService.post(
        'generate-onboard-link',
        data: {
          'stripe_acc_id': stripeAccountId,
          'refresh_url': 'https://toysell.hboxdigital.website/api/refresh',
          'return_url': 'https://toysell.hboxdigital.website/api/return',
        },
        token: token,
      );

      final onboardJson = jsonDecode(onboardResponse.body);

      if (onboardResponse.statusCode == 200 &&
          onboardJson['error'] == false &&
          onboardJson['data'] != null &&
          onboardJson['data'].toString().startsWith("http")) {
        // ✅ Open onboarding link in WebView
        Get.to(() => StripeWebViewScreen(url: onboardJson['data']));
      } else {
        Get.snackbar("Error",
            onboardJson['message'] ?? "Failed to generate onboarding link");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
