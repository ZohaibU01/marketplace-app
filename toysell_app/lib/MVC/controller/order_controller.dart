import 'dart:convert';
import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../model/my_shop_order_model.dart';
import '../model/order_model.dart';


class OrderController extends GetxController {
  var isLoading = false.obs;
  RxList<MyOrderModel> orders = <MyOrderModel>[].obs;
  RxList<MyShopOrderModel> shopOrders = <MyShopOrderModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    Future.wait([
      fetchMyOrders(),
      fetchMyShopOrders(),
    ]);
  }

  // Fetch My Orders
  Future<void> fetchMyOrders() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        'my-orders',
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['error'] == false) {
          final ordersData = responseData['data']['data'] as List;
          orders.value = ordersData.map((order) => MyOrderModel.fromJson(order)).toList();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch orders.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch orders. Status code: ${response.statusCode}");
      }
    } catch (e,s) {
      print(e.toString() + s.toString());
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch My Shop Orders
  Future<void> fetchMyShopOrders() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        'my-shop-orders',
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['error'] == false) {
          final shopOrdersData = responseData['data']['data'] as List;
          shopOrders.value = shopOrdersData
              .map((order) => MyShopOrderModel.fromJson(order))
              .toList();
          // Get.snackbar(
          //     "Success", responseData['message'] ?? "Shop orders fetched successfully.");
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch shop orders.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch shop orders. Status code: ${response.statusCode}");
      }
    } catch (e, s) {
      print(e.toString() + s.toString());
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Update Order Status
  Future<void> updateOrderStatus(int orderId, String status) async {
    isLoading.value = true;
    try {
      final response = await ApiService.post(
        'update-order-status',
        data: {
          'order_id': orderId.toString(),
          'status': status,
        },
        token: DataStroge.accesstoken.value,
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          Get.snackbar("Success", responseData['message'] ?? "Order status updated successfully.");
          fetchMyOrders();
          fetchMyShopOrders();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to update order status.");
        }
      } else {
        Get.snackbar("Error", "Failed to update order status. Status code: ${response.statusCode}");
      }
    } catch (e, s) {
      print(e.toString() + s.toString());
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
