import 'dart:developer';

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetController extends GetxController {
  static InternetController? _instance;
  static InternetController get getInstance =>
      _instance ??= InternetController();

  RxBool isInternetConnected = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await internetCheckerFun();
  }

  internetCheckerFun() async {
    try {
      log('internet Checker hit ====>>> $isInternetConnected');

      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        isInternetConnected(true);

        return isInternetConnected;
      } else {
        isInternetConnected(false);
        return isInternetConnected;
      }
    } catch (e) {
      log('error in internet_Checker: $e');
    }
  }
}
