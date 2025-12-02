import 'dart:convert';
import 'package:get/get.dart';
import '../../api_service.dart';
import '../model/helpcenter_topic_model.dart';

class HelpCenterController extends GetxController {
  var isLoading = false.obs;
  RxList<HelpCenterTopic> topics = <HelpCenterTopic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHelpCenterTopics();
  }

  Future<void> fetchHelpCenterTopics() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get('helpcenter');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          topics.value = (responseData['data'] as List)
              .map((topic) => HelpCenterTopic.fromJson(topic))
              .toList();
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch help center topics');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
