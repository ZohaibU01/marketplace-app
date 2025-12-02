import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class internetChecker extends GetxController {
  static internetChecker? _instance;
  static internetChecker get getInstance => _instance ??= internetChecker();

  RxBool isInternetConnected = false.obs;

  internet_Checker() async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        isInternetConnected.value = true;

        return isInternetConnected;
      } else {
        isInternetConnected(false);
        return isInternetConnected;
      }
    } catch (e) {
      print('error in internet_Checker: $e');
    }
  }
}
