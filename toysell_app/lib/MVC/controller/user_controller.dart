import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../helper/data_storage.dart';
import '../model/userModel.dart';
import '../../api_service.dart';
import '../../helper/snack_bar_helper.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var users = <UserModel>[].obs;
  Rx<UserModel> user = UserModel(
    id: 0,
    name: "",
    email: "",
    type: "",
    fcmId: "",
    notification: 0,
    firebaseId: "",
    createdAt: "",
    updatedAt: "",
    showPersonalDetails: 0,
    isVerified: 0,
    stripeAccountId: null,
    onboardLink: null,
    averageRating: null,
    ratings: [],
    sellerReviews: [],
    userReports: [],
    fcmTokens: [],
    items: [], // Initialize with an empty list of items
  ).obs;
  // final OrderController productController = Get.find<OrderController>();

  @override
  void onInit(){
    super.onInit();
    Future.wait([
      fetchAllUsers(),
    ]);
  }

  /// Fetch all users
  Future<void> fetchAllUsers() async {
    isLoading.value = true;
    try {
      http.Response response = await ApiService.get('get-all-users');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (!responseData['error']) {
          // Parse the list of users
          var fetchedUsers = (responseData['data'] as List)
              .map((user) => UserModel.fromJson(user))
              .toList();
          users.value = fetchedUsers;
        } else {
          SnackbarHelper.showError("Error", responseData['message']);
        }
      } else {
        SnackbarHelper.showError("Error", "Failed to fetch users.");
      }
    } catch (e, s) {
      print(e.toString() + s.toString());
      SnackbarHelper.showError("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch user details by ID
  Future<void> getUserDetails(int userId,String token) async {
    // isLoading.value = true;
    try {
      final data = {"id": userId.toString()};
      http.Response response = await ApiService.post('user-profile', data: data,token: token);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData != null) {
          user.value = UserModel.fromJson(responseData["data"]);
        } else {
          SnackbarHelper.showError("Error", "Failed to fetch user details.");
        }
      }
      else {
        SnackbarHelper.showError("Error", "Failed to fetch user details.");
      }
    } catch (e,s) {
      print(e.toString() + s.toString());
      SnackbarHelper.showError("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String countryCode,
    required bool showPersonalDetails,
    File? profileImage,
  }) async {
    isLoading.value = true;
    final token = DataStroge.accesstoken.value;
    final _dio = dio.Dio();

    var serverFileName = "profile.${profileImage?.path.split('.').last}";

    try {
       final formData = dio.FormData.fromMap({
    "name": name,
    "email": email,
    "mobile": mobile,
    "address": address,
    "country_code": countryCode,
    "show_personal_details": showPersonalDetails ? "1" : "0",
    "fcm_id": "",
    if (profileImage != null)
      "profile": await dio.MultipartFile.fromFile(
        profileImage.path,
        filename: serverFileName,
      ),
  });

      final response = await _dio.post(
        "${ApiService.baseUrl}/update-profile",
        data: formData,
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          contentType: "multipart/form-data",
        ),
      );

      final responseData = response.data;

      if (responseData["error"] == false) {
        SnackbarHelper.showSuccess("Success", responseData["message"] ?? "Profile updated");
        await getUserDetails(user.value.id, token); // Refresh the user profile
        Get.back(); // Close the screen if needed
      } else {
        SnackbarHelper.showError("Error", responseData["message"]);
      }
    } catch (e) {
      SnackbarHelper.showError("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetController(){
    user.value = UserModel(
      id: 0,
      name: "",
      email: "",
      type: "",
      fcmId: "",
      notification: 0,
      firebaseId: "",
      createdAt: "",
      updatedAt: "",
      showPersonalDetails: 0,
      isVerified: 0,
      stripeAccountId: null,
      onboardLink: null,
      averageRating: null,
      ratings: [],
      sellerReviews: [],
      userReports: [],
      fcmTokens: [],
      items: [], // Initialize with an empty list of items
    );
  }

  int getTotalSales(int userId)=> user.value.items.where((p) => p.status == "sold out",).toList().length;
  int getTotalPurchases(int userId)=> user.value.items.where((p) => p.status == "sold out" && p.userId != userId,).toList().length;
}
