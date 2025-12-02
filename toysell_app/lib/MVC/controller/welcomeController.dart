import 'dart:async';
import 'dart:developer';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toysell_app/MVC/view/loginScreen/selectSignInScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/welcomeScreen.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:toysell_app/services/notification_service.dart';

class WelcomeController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    Timer(
      const Duration(seconds: 3),
      () async {
        FlutterNativeSplash.remove();
      },
    );
    await isloggedcheck();
  }

  Future<void> _requestLocationPermission() async {
    // Check if permission is already granted
    if (await Permission.location.isGranted) {
      // Permission is already granted
      print("Location permission is already granted");
    } else {
      // Request permission
      final status = await Permission.location.request();
      print("Permission status: $status");
      if (status == PermissionStatus.granted) {
        print("Location permission granted");
      } else if (status == PermissionStatus.denied) {
        print("Location permission denied");
      } else if (status == PermissionStatus.permanentlyDenied) {
        print("Location permission permanently denied");
        // Handle this case if needed
      } else {
        print("Location permission unknown");
        // Handle this case if needed
      }
    }
  }

  isloggedcheck() async {
    await DataStroge.getInstance.getUserData();

    log("userToken:${DataStroge.accesstoken.value}");
    Timer(
      Duration(seconds: 6),
      () {
        if (DataStroge.accesstoken.value != '') {
          Get.to(BottomNavBar());
          DataStroge.currentUser.value?.fcmId = NotificationService().fcmToken;
        } else if(DataStroge.showOnboarding.value){
          Get.to(Selectsigninscreen());
        }else{
          Get.to(welcomeScreen());
        }
      },
    );
  }
}
