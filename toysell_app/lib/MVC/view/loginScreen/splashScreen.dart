import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:toysell_app/MVC/controller/welcomeController.dart';

class Splashscreen extends StatelessWidget {
  Splashscreen({super.key});

  @override
  var controller = Get.put(WelcomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 400.sp,
                width: 400.sp,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage('assets/images/splash_giff.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
