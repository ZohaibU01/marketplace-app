import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toysell_app/MVC/model/userModel.dart';

class DataStroge extends GetxController {
  static DataStroge? _instance;
  static DataStroge get getInstance => _instance ??= DataStroge();
  static SharedPreferences? _pref;

  static Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  static RxString accesstoken = ''.obs;
  static RxString lang = ''.obs;
  static RxBool showOnboarding = true.obs;

  Future<SharedPreferences> _getPref() async {
    if(_pref != null){
      return _pref!;
    }
    _pref = await SharedPreferences.getInstance();
    return _pref!;
  }


  // Insert User Data
  Future<void> insertUserData(UserModel userData, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store token
    await prefs.setString('token', token);

    // Store user data
    final userJson = userData.toJson();
    userJson.forEach((key, value) async {
      if (value != null) {
        if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else {
          await prefs.setString(key, value.toString());
        }
      }
    });

    // Update Rx variables
    accesstoken.value = token;
    currentUser.value = userData;
  }

  // Retrieve User Data
  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userJson = {
      'id': prefs.getInt('id'),
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'mobile': prefs.getString('mobile'),
      'emailVerifiedAt': prefs.getString('emailVerifiedAt'),
      'profile': prefs.getString('profile'),
      'type': prefs.getString('type'),
      'fcmId': prefs.getString('fcmId'),
      'notification': prefs.getInt('notification'),
      'firebaseId': prefs.getString('firebaseId'),
      'address': prefs.getString('address'),
      'createdAt': prefs.getString('createdAt'),
      'updatedAt': prefs.getString('updatedAt'),
      'deletedAt': prefs.getString('deletedAt'),
      'countryCode': prefs.getString('countryCode'),
      'showPersonalDetails': prefs.getInt('showPersonalDetails'),
      'isVerified': prefs.getInt('isVerified'),
    };

    currentUser.value = UserModel.fromJson(userJson);

    accesstoken.value = prefs.getString('token') ?? '';
  }


  static Future<void> loadOnboarding() async{
    final SharedPreferences? prefs = _pref;
    showOnboarding.value = prefs?.getBool('showOnboarding') ?? true;
  }

  static Future<void> setOnboardingFalse() async{
    final SharedPreferences? prefs = _pref;
    await prefs?.setBool('showOnboarding',false);
    showOnboarding.value = false;
  }

  Future<void> loadLang() async{
    final SharedPreferences? prefs = _pref;
    lang.value = prefs?.getString('lang') ?? "en";
  }

  Future<void>updateLang(String lan) async{
    final SharedPreferences prefs = await _getPref();
    await prefs.setString('lang', lan).then((_) => lang.value = lan,);
  }

  // Logout
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();
    accesstoken.value = '';
    currentUser.value = null;

    log('User logged out and preferences cleared.');
  }
}
