import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataStorage extends GetxController {
  static LocalDataStorage? _instance;
  static LocalDataStorage get getInstance => _instance ??= LocalDataStorage();
  late SharedPreferences _pref;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static RxString username = ''.obs;
  static RxString userEmail = ''.obs;
  static RxString userDOB = ''.obs;
  static RxString userImage = ''.obs;
  static RxString userPhone = ''.obs;
  static RxString userBio = ''.obs;
  static RxString usercountry = ''.obs;
  static RxString currentUserId = ''.obs;
  static RxString fcmToken = ''.obs;
  static RxString DeviceID = ''.obs;
  static RxString lang = ''.obs;

  insertDeviceAndFCMInformation({FcmToken, deviceID}) async {
    final SharedPreferences? prefs = await _prefs;
    await prefs?.setString('fcmToken', FcmToken);
    await prefs?.setString('DeviceID', deviceID);

    fcmToken.value = FcmToken;
    DeviceID.value = deviceID;
  }

  updateUserData(
      {fullname, phone, bio, DOB, Country, required List<String> image}) async {
    final SharedPreferences? prefs = await _prefs;

    await prefs?.setString('fullName', fullname);
    await prefs?.setString('phonenumber', phone);
    await prefs?.setString('country', Country);
    await prefs?.setString('bio', bio);
    await prefs?.setString('DOB', DOB);
    await prefs?.setString('DOB', DOB);

    username.value = fullname;
    userPhone.value = phone;
    userBio.value = bio;
    userDOB.value = DOB;
    usercountry.value = Country;
    if (image.isNotEmpty) {
      await prefs?.setString('profile', image.last);
      userImage.value = image.last;
    }
  }

  getUserData() async {
    final SharedPreferences? prefs = await _prefs;
    currentUserId.value = prefs?.getString('id') ?? "";
    username.value = prefs?.getString('fullName') ?? "";
    userEmail.value = prefs?.getString('email') ?? "";
    userBio.value = prefs?.getString('bio') ?? "";
    userDOB.value = prefs?.getString('DOB') ?? "";
    usercountry.value = prefs?.getString('country') ?? "";
    userImage.value = prefs?.getString('profile') ?? "";
  }

  Future<void> loadLang() async{
    final SharedPreferences? prefs = await _prefs;
    lang.value = prefs?.getString('lang') ?? "en";
  }

  Future<void>updateLang(String lan) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('lang', lan).then((_) => lang.value = lan,);
  }

  logout(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await supabse_DB.getInstance.DeleteFcmtoken(context);
    await preferences.clear();
    currentUserId.value = "";
    username.value = "";
    userEmail.value = "";
    userBio.value = "";
    userDOB.value = "";
    usercountry.value = "";
    userImage.value = "";
  }
}