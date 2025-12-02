import 'dart:io';

import 'package:toysell_app/MVC/controller/homeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import '../../../components/round_button.dart';
import '../../../constant/flutter_toast.dart';
import '../../../helper/internet_controller.dart';

class uploadprofileImageScreen extends StatelessWidget {
  uploadprofileImageScreen({super.key});

  final internetController = Get.put(InternetController());
  final HomeController = Get.put(homeController());
  final getxController = Get.put(GetxControllersProvider());

  RxBool apihitting = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(dispose: (state) {
      getxController.imagePath.value = '';
    }, builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwelcomeScreen,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              centerTitle: true,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: Text(
                'upload Profile Image',
                style: TextStyle(
                    color: themecontroller.colorPrimaryBlue,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              )),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Obx(
                    () => SpringWidget(
                      onTap: () async {
                        await getxController.getImage();
                      },
                      child: getxController.imagePath.value != ''
                          ? Container(
                              height: 400.sp,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.sp),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1.5,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(getxController.imagePath.value),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 400.sp,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.sp),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1.5,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_pin,
                                    color: Colors.black.withOpacity(0.2),
                                    size: 30.sp,
                                  ),
                                  Text(
                                    'Upload your profile picture',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => RoundButton(
                gradient: false,
                margin: 0,
                backgroundColor: themecontroller.colorPrimaryBlue,
                height: 45.sp,
                disabled: apihitting.value,
                loading: apihitting.value,
                borderRadius: 10.sp,
                title: 'upload',
                iconColor: themecontroller.colorwhite,
                textColor: themecontroller.colorwhite,
                onTap: () async {
                  await internetController.internetCheckerFun();

                  if (getxController.imagePath.value != '') {
                    if (internetController.isInternetConnected.value == true) {
                      apihitting.value = true;
                      // await AppService.getInstance.uploadProfilepictureApi(
                      //     context, getxController.imagePath.value);
                      apihitting.value = false;
                    } else {
                      FlutterToastDisplay.getInstance
                          .showToast("Please check your internet");
                    }
                  } else {
                    FlutterToastDisplay.getInstance.showToast(
                        "Please select an image for profile picture");
                  }
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
