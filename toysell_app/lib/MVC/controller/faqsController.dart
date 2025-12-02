import 'dart:convert';
import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../model/faq_model.dart';

class FAQsController extends GetxController {
  var isLoading = false.obs;
  var faqsList = <FAQModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFAQs();
  }

  Future<void> fetchFAQs() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(
        'faq',
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (!responseData['error']) {
          final List<dynamic> faqData = responseData['data'];
          faqsList.value = faqData.map((faq) => FAQModel.fromJson(faq)).toList();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch FAQs.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch FAQs. Status code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}