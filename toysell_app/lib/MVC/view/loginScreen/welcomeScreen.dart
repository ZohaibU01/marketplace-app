import 'package:toysell_app/MVC/view/loginScreen/sliderScreen.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';

class welcomeScreen extends StatelessWidget {
  const welcomeScreen({super.key});

  @override
  

  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(initState: (state) async {
    }, builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwelcomeScreen,
        child: Scaffold(
            body: Column(
          children: [
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.sp)),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/welocmebg.png",
                              ))),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.sp))),
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white, // Shadow color
                      offset: Offset(0, -5),
                      blurRadius: 60,
                      spreadRadius: 60,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10.sp,right: 10.sp,bottom: 26.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'buying_and'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: 'selling_pre_loved'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'items'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.sp,right: 6.sp),
                        child: RoundButton(
                          height: 44.sp,
                          gradient: true,
                          borderRadius: 30.sp,
                          title: 'get_started'.tr,
                          textColor: Colors.black.withOpacity(0.5),
                          onTap: () {
                            Navigation.getInstance.pagePushAndReplaceNavigation(
                                context, const Sliderscreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      );
    });
  }
}

//
