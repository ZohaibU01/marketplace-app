import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'dart:convert';

import 'package:toysell_app/helper/data_storage.dart';

class BoostingController extends GetxController {
  var isLoading = false.obs;
  var boostingPackages = [].obs;

  @override
  void onInit() {
    super.onInit();
    Future.wait(
        [
          fetchBoostingPackages(),
        ]
    );
  }

  Future<void> fetchBoostingPackages() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('get-package');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          // Fetch and sort packages by price
          boostingPackages.value = responseData['data']
            ..sort((a, b) {
              double priceA = double.tryParse(a['final_price'].toString()) ?? 0.0;
              double priceB = double.tryParse(b['final_price'].toString()) ?? 0.0;
              return priceA.compareTo(priceB);
            });
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch packages.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch packages.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Buy Package API Integration
  Future<bool> buyPackage({
    required int packageId,
    required String stripeToken,
    required int itemId,
  }) async {
    isLoading.value = true;
    try {
      final response = await ApiService.post(
        'buy-package',
        token: DataStroge.accesstoken.value,
        data: {
          'package_id': packageId.toString(),
          'payment_method_id': stripeToken,
          'item_id': itemId.toString(),
        },
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['error'] == false) {
        Get.snackbar("Success", responseData['message'] ?? "Package purchased successfully.");
        return true;
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Failed to purchase package.");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
