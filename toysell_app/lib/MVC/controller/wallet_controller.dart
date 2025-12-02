import 'dart:convert';
import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../model/transaction_model.dart';
import '../model/withdraw_model.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  var walletAmount = 0.0.obs;
  RxList<Transaction> transactions = <Transaction>[].obs;
  RxList<WithdrawModel> withdraws = <WithdrawModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.wait([
    fetchWalletData(), fetchTransactions(), fetchWithdrawHistory(),
    ]);
  }

  Future<void> fetchWalletData() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('my-wallet', token: DataStroge.accesstoken.value);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['error']) {
          walletAmount.value = double.tryParse(data['data']['available_amount'].toString()) ?? 0.0;
          transactions.value = (data['data']['orders'] as List<dynamic>).map((t) => Transaction.fromJson(t),).toList();
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch wallet data.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch Transactions
  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('my-transactions', token: DataStroge.accesstoken.value);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['error']) {
          transactions.value = (data['data']['purchased_items'] as List)
              .map((item) => Transaction.fromJson(item))
              .toList();
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch transactions.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWithdrawHistory() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('withdrawl-history', token: DataStroge.accesstoken.value);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['error']) {
          withdraws.value = (data['data']['data'] as List)
              .map((item) => WithdrawModel.fromJson(item))
              .toList();
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch withdrawal history.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitWithdrawalRequest({
    required String stripeAccountId,
    required List<int> paymentIds,
  }) async {
    isLoading.value = true;
    try {
      final formData = {
        'stripe_acc_id': stripeAccountId,
        'payment_ids[]': paymentIds.map((id) => id.toString()).toList().toString(),
      };

      final response = await ApiService.post(
        'withdraw',
        data: formData,
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['error']) {
          Get.snackbar("Success", data['message']);
          await fetchWalletData();       // Optionally refresh wallet state
          await fetchWithdrawHistory();  // Optionally refresh withdrawal list
        } else {
          Get.snackbar("Error", data['message']);
        }
      } else {
        Get.snackbar("Error", "Withdrawal failed. Try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
