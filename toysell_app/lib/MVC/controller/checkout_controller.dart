import 'dart:convert';

import 'package:get/get.dart';
import 'package:toysell_app/MVC/model/productModel.dart';

import '../../api_service.dart';
import '../../helper/data_storage.dart';

class CheckoutController extends GetxController {
  var billingAddress = "123, Main Street, City".obs;
  var shippingAddress = "456, Elm Street, City".obs;
  var sameAsBilling = true.obs;
  var paymentMethod = "online".obs;
  var isLoading = false.obs;

  void toggleSameAsBilling(bool value) {
    sameAsBilling.value = value;
    if (value) {
      shippingAddress.value = billingAddress.value;
    }
  }

  void editAddress({required bool isBilling}) {
    // Logic to open an address editing screen
    if (isBilling) {
      billingAddress.value = "New Billing Address"; // Example
    } else {
      shippingAddress.value = "New Shipping Address"; // Example
    }
  }

  void setPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void placeOrder(ProductModel product) {
    if (paymentMethod.value.isEmpty) {
      Get.snackbar("Error", "Please select a payment method");
      return;
    }

    // Logic to place the order
    Get.snackbar("Success", "Order placed successfully");
  }

  // Checkout method
  Future<bool> checkout({
    required int itemId,
    required double amount,
    required String currency,
    required String token,
    required int customerId,
    required String address,
    required String shippingAddress,
    bool save = true,
  }) async {
    try {
      isLoading.value = true;

      final data = {
        'item_id': itemId.toString(),
        'amount': amount.toString(),
        'currency': currency,
        'token': token,
        'payment_method_id': token,
        // 'customer_id': customerId.toString(),
        'save': save ? "1" : "0",
        'address': address,
        'billing_address': address,
        'shipping_address': shippingAddress,
      };

      final response = await ApiService.post(
        'checkout',
        data: data,
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] != null && responseData['success'] == true) {
          Get.snackbar("Success", responseData['message'] ?? "Checkout successful");
          return true;
        } else {
          Get.snackbar("Error", responseData['message'] ?? "An error occurred during checkout");
          return false;
        }
      } else {
        Get.snackbar("Error", "Failed to complete checkout: ${response.reasonPhrase}");
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
