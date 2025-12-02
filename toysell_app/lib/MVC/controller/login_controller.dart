import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:toysell_app/MVC/model/userModel.dart';
import 'package:toysell_app/services/notification_service.dart';
import 'dart:convert';
import '../../api_service.dart';
import '../../helper/data_storage.dart';
import '../../helper/snack_bar_helper.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  // Observables
  var isLoading = false.obs;
var isAppleLoading = false.obs;
  // Google Sign-In Instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Signup function
  Future<bool> signup({
    required String email,
    required String password,
    String? phone,
    String? countryCode,
    String platformType = "android",
    String flag = "1",
  }) async {
    isLoading.value = true;

    try {
      // Prepare data
      final data = {
        "type": "email",
        "email": email,
        "password": password,
        "country_code": countryCode ?? "1",
        "platform_type": platformType,
        "flag": flag,
        "fcm_id": NotificationService().fcmToken,
      };

      // API Call
      http.Response response = await ApiService.post('user-signup', data: data);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check for error field in response
        if (responseData['error'] == true) {
          SnackbarHelper.showError(
              "Error", responseData["message"] ?? "Signup failed");
          return false;
        } else {
          var userData = UserModel.fromJson(responseData['data']);
          userData.fcmId = NotificationService().fcmToken;
          var token = responseData['token'];

          DataStroge.getInstance.insertUserData(userData, token);
          await ApiService.get('assign-free-package', token: token);
          print(responseData);
          return true;
        }
      } else {
        // Handle other status codes
        final errorData = jsonDecode(response.body);
        SnackbarHelper.showError(
            "Error", errorData["message"] ?? "Signup failed");
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError("Error", "Something went wrong: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login function
  Future<bool> login({
    required String email,
    required String password,
    String type = "email",
    String platformType = "android",
  }) async {
    isLoading.value = true;

    try {
      // Prepare data
      final data = {
        "type": type,
        "email": email,
        "password": password,
        "platform_type": platformType,
        "fcm_id": NotificationService().fcmToken,
      };

      // API Call
      http.Response response = await ApiService.post('user-login', data: data);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check for error field in response
        if (responseData['error'] == true) {
          SnackbarHelper.showError(
              "Error", responseData["message"] ?? "Login failed");
          return false;
        } else {
          var userData = UserModel.fromJson(responseData['data']);
          userData.fcmId = NotificationService().fcmToken;
          var token = responseData['token'];

          DataStroge.getInstance.insertUserData(userData, token);
          // SnackbarHelper.showSuccess("Success", "Login successful!");
          print(responseData);
          return true;
        }
      } else {
        // Handle other status codes
        final errorData = jsonDecode(response.body);
        SnackbarHelper.showError(
            "Error", errorData["message"] ?? "Login failed");
        return false;
      }
    } catch (e, s) {
      print(e.toString() + s.toString());
      SnackbarHelper.showError("Error", "Something went wrong: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

Future<bool> signInWithApple({String platformType = "ios"}) async {
  try {
    isAppleLoading.value = true;

    // Get Apple credentials
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
print(credential);
    // Prepare data for API
    final data = {
      "type": "apple",
      "fcm_id": NotificationService().fcmToken,
      "firebase_id": NotificationService().fcmToken,
      "access_token": credential.identityToken ?? "",
      "platform_type": platformType,
      // "email": credential.email ?? "",
    };
    print(data);

    // API Call
    http.Response response = await ApiService.post('user-signup', data: data);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['error'] == true) {
        SnackbarHelper.showError("Error", responseData["message"] ?? "Apple Login failed");
        return false;
      } else {
        var userData = UserModel.fromJson(responseData['data']);
        var token = responseData['token'];

        DataStroge.getInstance.insertUserData(userData, token);
        print(responseData);
        return true;
      }
    } else {
      final errorData = jsonDecode(response.body);
      print(errorData["message"] );
      SnackbarHelper.showError("Error", errorData["message"] ?? "Apple Login failed");
      return false;
    }
  } catch (e) {
    SnackbarHelper.showError("Error", "Something went wrong: $e");
    return false;
  } finally {
    isAppleLoading.value = false;
  }
}

  // Google Login function
  Future<bool> loginWithGoogle({
    String platformType = "android",
  }) async {
    isLoading.value = true;

    try {
      // Attempt Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackbarHelper.showError("Error", "Google Sign-In canceled");
        return false;
      }

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print(googleAuth.accessToken);
      // Prepare data
      final data = {
        "type": "google",
        // "email": googleUser.email,
        "fcm_id": NotificationService().fcmToken,
        "firebase_id": NotificationService().fcmToken,
        "access_token": googleAuth.accessToken ?? "",
        "platform_type": platformType,
      };

      // API Call
      http.Response response = await ApiService.post('user-signup', data: data);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check for error field in response
        if (responseData['error'] == true) {
          SnackbarHelper.showError(
              "Error", responseData["message"] ?? "Google Login failed");
          return false;
        } else {
          var userData = UserModel.fromJson(responseData['data']);
          var token = responseData['token'];

          DataStroge.getInstance.insertUserData(userData, token);
          print(responseData);
          return true;
        }
      } else {
        // Handle other status codes
        final errorData = jsonDecode(response.body);
        SnackbarHelper.showError(
            "Error", errorData["message"] ?? "Google Login failed");
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError("Error", "Something went wrong: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Account function
  Future<bool> deleteAccount() async {
    isLoading.value = true;

    try {
      // API Call
      http.Response response = await ApiService.delete(
        'delete-user',
        token: DataStroge.accesstoken.value,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check for error field in response
        if (responseData['error'] == true) {
          SnackbarHelper.showError(
              "Error", responseData["message"] ?? "Account deletion failed");
          return false;
        } else {
          // Clear user data from storage
          await DataStroge.getInstance.logout();
          SnackbarHelper.showSuccess(
              "Success", "Account deleted successfully!");

          // Navigate to the login screen
          // Get.reset();
          // Get.to(AuthenticationScreen());
          return true;
        }
      } else {
        // Handle other status codes
        final errorData = jsonDecode(response.body);
        SnackbarHelper.showError(
            "Error", errorData["message"] ?? "Account deletion failed");
        return false;
      }
    } catch (e) {
      SnackbarHelper.showError("Error", "Something went wrong: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
