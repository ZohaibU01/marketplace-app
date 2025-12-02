import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';
import '../model/chat_message_model.dart';
import '../model/chat_model.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var isLoading = false.obs;
  var isSending = false.obs;
  var buyerChats = <ChatItem>[].obs;
  var sellerChats = <ChatItem>[].obs;
  var messages = <ChatMessage>[].obs;
  final searchQuery = ''.obs;
  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    Future.wait([
      fetchBuyerChats(),
      fetchSellerChats(),
    ]);
  }

  // Fetch Buyer Chats
  Future<void> fetchBuyerChats() async {
    await _fetchChats('buyer', buyerChats);
  }

  // Fetch Seller Chats
  Future<void> fetchSellerChats() async {
    await _fetchChats('seller', sellerChats);
  }

  // Generic method to fetch chats
  Future<void> _fetchChats(String type, RxList<ChatItem> chatList) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(
        'chat-list',
        token: DataStroge.accesstoken.value,
        queryParameters: {'type': type},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          final chatData = ChatListResponse.fromJson(responseData);
          chatList.value = chatData.data.chatItems;
        } else {
          Get.snackbar("Error", responseData['message']);
        }
      } else {
        Get.snackbar(
            "Error", "Failed to fetch chats. Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChatMessages(int itemOfferId) async {
    // isLoading.value = true;
    try {
      final response = await ApiService.get(
        'chat-messages',
        token: DataStroge.accesstoken.value,
        queryParameters: {'item_offer_id': itemOfferId.toString()},
      );

      if (response.statusCode == 200) {
        print(" hit chat-messages api ✅ ");
        final responseData = jsonDecode(response.body);
        print(responseData);
        if (responseData['error'] == false) {
          final messageData = ChatMessageResponse.fromJson(responseData);
          messages.value = messageData.data.chat.data;
          print(
              "messages:${messages.value.length}, item offer id: ${itemOfferId} ");
        } else {
          Get.snackbar("Error", responseData['message']);
        }
      } else {
        Get.snackbar("Error",
            "Failed to fetch messages. Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      // isLoading.value = false;
    }
  }

  // Send Message
  Future<void> sendMessage({
    required int itemOfferId,
    required String message,
    File? file,
    File? audio,
  }) async {
    isSending.value = true;
    try {
      final url = Uri.parse('${ApiService.baseUrl}/send-message');

      // Build request body
      var request = http.MultipartRequest('POST', url)
        ..fields['item_offer_id'] = itemOfferId.toString()
        ..fields['message'] = message;

      // Attach file if provided
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
      }

      // Attach audio if provided
      if (audio != null) {
        request.files
            .add(await http.MultipartFile.fromPath('audio', audio.path));
      }

      // Add headers
      request.headers['Authorization'] =
          'Bearer ${DataStroge.accesstoken.value}';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);
        print(" hit send-message api ✅ ");
        print(" send-message api Response:${responseData} ");

        // var data = ChatMessage.fromJson(responseData["data"]);
        // messages.add(data);
        // message.r
        if (responseData['error'] == false) {
          print("fetching message ✅ ");
          fetchChatMessages(itemOfferId);
        } else {
          Get.snackbar(
              'Error', responseData['message'] ?? 'Failed to send message.');
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to send message. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isSending.value = false;
    }
  }
}
