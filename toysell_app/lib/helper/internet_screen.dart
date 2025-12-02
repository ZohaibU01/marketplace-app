import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:toysell_app/constant/theme.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    RxBool isDarkTheme = false.obs;
    return GetBuilder<ThemeHelper>(
      builder: (themeController) => AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: themeController.colorCanvas,
          systemNavigationBarColor: themeController.colorCanvas,
          statusBarBrightness:
              isDarkTheme.value ? Brightness.dark : Brightness.light,
          statusBarIconBrightness:
              isDarkTheme.value ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness:
              isDarkTheme.value ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: themeController.colorCanvas,
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/images/no_internet.json',
                    width: 300,
                    height: 300,
                    repeat: true,
                    reverse: false,
                    animate: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Please turn on your Internet',
                      style: TextStyle(
                          color: themeController.textcolor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: CircleAvatar(
                      backgroundColor:
                          themeController.colorPrimary.withOpacity(0.5),
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Lottie.asset(
                          'assets/images/reload.json',
                          repeat: true,
                          reverse: false,
                          animate: true,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
