import 'package:get/get.dart';
import 'package:toysell_app/api_service.dart';
import 'dart:convert';
import '../model/userModel.dart';

class FollowFollowingController extends GetxController {
  var isLoading = false.obs;
  var followers = <UserModel>[].obs;
  var following = <UserModel>[].obs;

  Future<void> getFollowers(int userId, String token) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('user-followers/$userId', token: token);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          followers.value = (responseData['data'] as List)
              .map((item) => UserModel.fromJson(item['follower']))
              .toList();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch followers.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch followers.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getFollowing(int userId, String token) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('user-following/$userId', token: token);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          following.value = (responseData['data'] as List)
              .map((item) => UserModel.fromJson(item['following']))
              .toList();
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to fetch following.");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch following.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> followUser({required int userId, required String token}) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('follow-user/$userId', token: token,);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          Get.snackbar("Success", "You are now following the user.");
          await getFollowers(userId, token);
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to follow user.");
        }
      } else {
        Get.snackbar("Error", "Failed to follow user.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unfollowUser({required int userId, required String token}) async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('unfollow-user/$userId', token: token,);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] == false) {
          Get.snackbar("Success", "You have unfollowed the user.");
          await getFollowers(userId, token);
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to unfollow user.");
        }
      } else {
        Get.snackbar("Error", "Failed to unfollow user.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
