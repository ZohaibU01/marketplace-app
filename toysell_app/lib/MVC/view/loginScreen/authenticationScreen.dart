import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/src/material/carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/controller/login_controller.dart';
import 'package:toysell_app/MVC/view/loginScreen/SignInScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/signupScreen.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import '../../../helper/internet_controller.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({super.key});

  final internetController = Get.put(InternetController());
  final loginController = Get.put(LoginController());

  final List<String> FirstRowimagelist = [
    'assets/images/slider1.png',
    'assets/images/slider2.png',
    'assets/images/slider3.png',
  ];

  final List<String> SecondRowimagelist = [
    'assets/images/slider4.png',
    'assets/images/slider5.png',
    'assets/images/slider6.png',
  ];

  final List<String> thirdRowimagelist = [
    'assets/images/slider7.png',
    'assets/images/slider8.png',
    'assets/images/slider9.png',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwelcomeScreen,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 400.sp,
                      color: const Color(0xfff2f4f7),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CarouselSlider(
                                  items: FirstRowimagelist.map((imagePath) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            child: Image.asset(
                                              imagePath,
                                              height: 190,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 400.sp,
                                    aspectRatio: 16 / 12,
                                    viewportFraction: 0.4,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                    const Duration(milliseconds: 1000),
                                    autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1800),
                                    autoPlayCurve: Curves.linearToEaseOut,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.vertical,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CarouselSlider(
                                  items: SecondRowimagelist.map((imagePath) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            child: Image.asset(
                                              imagePath,
                                              height: 190,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 400.sp,
                                    aspectRatio: 16 / 12,
                                    viewportFraction: 0.4,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: true,
                                    autoPlay: true,
                                    autoPlayInterval:
                                    const Duration(milliseconds: 1500),
                                    autoPlayAnimationDuration:
                                    const Duration(milliseconds: 2000),
                                    autoPlayCurve: Curves.linearToEaseOut,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.vertical,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CarouselSlider(
                                  items: thirdRowimagelist.map((imagePath) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            child: Image.asset(
                                              imagePath,
                                              height: 190,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 400.sp,
                                    aspectRatio: 16 / 12,
                                    viewportFraction: 0.4,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                    const Duration(milliseconds: 1000),
                                    autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1800),
                                    autoPlayCurve: Curves.linearToEaseOut,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.vertical,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 550.sp,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.48),
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20.sp)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0, -5),
                            blurRadius: 60,
                            spreadRadius: 60,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'sign_up'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30.sp),
                          Obx(
                                () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.sp),
                              child: Column(
                                children: [
                                  // RoundButton(
                                  //   height: 40.sp,
                                  //   gradient: false,
                                  //   borderColor: Colors.black,
                                  //   borderWidth: 1.sp,
                                  //   borderRadius: 30.sp,
                                  //   title: 'continue_with_facebook'.tr,
                                  //   textColor: Colors.black,
                                  //   onTap: () {},
                                  //   icon: Image.asset(AssetPaths.facebookIcon),
                                  //   fontWeight: FontWeight.w400,
                                  // ),
                                  SizedBox(height: 10.sp),
                                  Obx(
                                    () =>  RoundButton(
                                      height: 40.sp,
                                      gradient: false,
                                      loading: loginController.isAppleLoading.value,
                                      disabled: loginController.isAppleLoading.value,
                                      borderColor: Colors.black,
                                      borderWidth: 1.sp,
                                      borderRadius: 30.sp,
                                      title: 'continue_with_apple'.tr,
                                      textColor: Colors.black,
                                      onTap: () async {
                                      bool success = await loginController.signInWithApple();
                                      if (success) {
                                        Navigation.getInstance.pagePushAndReplaceNavigation(
                                            context, BottomNavBar());
                                      }
                                    },
                                      icon: const Icon(Icons.apple),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10.sp),
                                  RoundButton(
                                    height: 40.sp,
                                    gradient: false,
                                    borderColor: Colors.black,
                                    borderWidth: 1.sp,
                                    borderRadius: 30.sp,
                                    title: 'continue_with_google'.tr,
                                    textColor: Colors.black,
                                    loaderColor: themecontroller.colorPrimary,
                                    loading: loginController.isLoading.value,
                                    onTap: () async {
                                      bool success = await loginController.loginWithGoogle();
                                      if (success) {
                                        Navigation.getInstance.pagePushAndReplaceNavigation(
                                            context, BottomNavBar());
                                      }
                                    },
                                    icon: Image.asset(AssetPaths.googleIcon),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 20.sp),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SpringWidget(
                                onTap: () {
                                  Navigation.getInstance.bottomToTop_PageNavigation(
                                      context, SignInScreen());
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'or_continue_with'.tr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'email'.tr,
                                        style: TextStyle(
                                          color: themecontroller.colorPrimary,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 0),
                              SizedBox(
                                  width: 32.sp,
                                  child: Divider(
                                    height: 10,
                                    color: themecontroller.colorPrimary,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
