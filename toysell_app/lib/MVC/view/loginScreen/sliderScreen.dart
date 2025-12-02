import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/view/loginScreen/selectSignInScreen.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';

class Sliderscreen extends StatefulWidget {
  const Sliderscreen({super.key});

  @override
  State<Sliderscreen> createState() => _SliderscreenState();
}

class _SliderscreenState extends State<Sliderscreen> {
  RxInt index = 0.obs;

  final List<Map<String, dynamic>> sliderData = [
    {
      'image': "p1.png",
      'heading': "slider_heading_1",
      'content': "slider_content_1",
    },
    {
      'image': "p2.png",
      'heading': "slider_heading_2",
      'content': "slider_content_2",
    },
    {
      'image': "p3.png",
      'heading': "slider_heading_3",
      'content': "slider_content_3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwelcomeScreen,
        child: Scaffold(
          body: Obx(
                () => Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/${sliderData[index.value]['image']}",
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 550.sp,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.sp, right: 4.sp, top: 12.sp),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            child: Text(
                              "slider_heading_${index.value + 1}".tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 38.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.sp),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            child: Text(
                              "slider_content_${index.value + 1}".tr.tr,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(left: 10.sp, right: 20.sp, bottom: 22.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                        () => Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: sliderData.asMap().entries.map(
                                            (entry) {
                                          int idx = entry.key;
                                          return SpringWidget(
                                            onTap: () => index.value = idx,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 2.sp),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 800),
                                                height: 8.sp,
                                                width: idx == index.value ? 30.w : 25.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.sp),
                                                  border: Border.all(
                                                    width: 1.sp,
                                                    color: themecontroller.colorPrimary.withOpacity(0.2),
                                                  ),
                                                  gradient: idx == index.value
                                                      ? themecontroller.backgroundGradient
                                                      : themecontroller.containerGradient,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                  SizedBox(height: 8.sp),
                                  SpringWidget(
                                    onTap: () {
                                      Navigation.getInstance.RightToLeft_PageNavigation(
                                        context,
                                        Selectsigninscreen(),
                                      );
                                    },
                                    child: Text(
                                      'skip'.tr,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.4),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SpringWidget(
                                onTap: () {
                                  if ((sliderData.length - 1) > index.value) {
                                    index.value++;
                                  } else {
                                    Navigation.getInstance.RightToLeft_PageNavigation(
                                      context,
                                      Selectsigninscreen(),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 40.sp,
                                  width: 100.sp,
                                  decoration: BoxDecoration(
                                    gradient: themecontroller.backgroundGradient,
                                    borderRadius: BorderRadius.circular(30.sp),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'next'.tr,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: themecontroller.bgcolor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_outlined,
                                          size: 18.sp,
                                          color: themecontroller.bgcolor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
