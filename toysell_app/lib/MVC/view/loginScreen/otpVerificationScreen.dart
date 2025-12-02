import 'package:toysell_app/MVC/view/loginScreen/SetNewPasswordScreen.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/components/logintextfield.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/flutter_toast.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/components/OtpfieldWidget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import '../../../components/round_button.dart';
import '../../../helper/internet_controller.dart';

class otpVerificationScreen extends StatelessWidget {
  otpVerificationScreen({
    super.key,
    required this.email,
    required this.type,
  });
  final String email;

  final String type;
  final internetController = Get.put(InternetController());

  final _formkey = GlobalKey<FormState>();

  final otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  RxBool apihitting = false.obs;
  RxBool ResendOtploading = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(
        initState: (state) {},
        builder: (themecontroller) {
          return AnnotatedRegion(
            value: themecontroller.systemUiOverlayStyleForwelcomeScreen,
            child: Scaffold(
              backgroundColor: themecontroller.backgoundcolor,
              resizeToAvoidBottomInset: true,
              body: Container(
                decoration: BoxDecoration(
                  color: themecontroller.backgoundcolor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20.sp,
                            ),
                            Container(
                              height: 150.sp,
                              width: 150.sp,
                              decoration: const BoxDecoration(

                                  // color: Colors.amber,
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                        "assets/images/logo.png",
                                      ))),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Form(
                        key: _formkey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themecontroller.colorPrimaryBlue,
                            boxShadow: [
                              BoxShadow(
                                color: themecontroller.colorPrimaryBlue
                                    .withOpacity(0.9), // Shadow color
                                offset: const Offset(0, 5),
                                blurRadius: 30,
                                spreadRadius: 0,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.sp),
                                topRight: Radius.circular(20.sp)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.sp),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.sp,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 300.sp,
                                      child: Text(
                                        'OTP Verification',
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 300.sp,
                                      child: Text(
                                        'Please enter OTP we have sent you on  \nyour email',
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 50.sp,
                                ),
                                OtpfieldWidget(otpController: otpController),
                                SizedBox(height: 20.sp),
                                SizedBox(
                                  height: 25.sp,
                                  
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 120.sp,
                                        child: Text(
                                          "Didn't receive a code? ",
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      Obx(
                                        () => ResendOtploading.value
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.sp),
                                                child: SizedBox(
                                                    width: 15.sp,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: themecontroller
                                                          .colorPrimary,
                                                    )),
                                              )
                                            : SpringWidget(
                                                onTap: () async {
                                                  ResendOtploading.value = true;
                                                  // await AppService.getInstance
                                                  //     .ResendOtp(context, email);
                                                  ResendOtploading.value =
                                                      false;
                                                },
                                                child: SizedBox(
                                                  width: 70.sp,
                                                  child: Text(
                                                    'Resend OTP',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 10.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                color: themecontroller.colorPrimaryBlue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => RoundButton(
                        gradient: false,
                        margin: 0,
                        backgroundColor: Colors.white,
                        height: 45.sp,
                        borderRadius: 10.sp,
                        loading: apihitting.value,
                        disabled: apihitting.value,
                        title: 'Verify OTP',
                        borderColor: Colors.white,
                        borderWidth: 1.sp,
                        iconColor: themecontroller.colorwhite,
                        textColor: Colors.black.withOpacity(0.5),
                        onTap: () async {
                          await internetController.internetCheckerFun();

                          if (_formkey.currentState!.validate()) {
                            if (internetController.isInternetConnected.value ==
                                true) {
                              apihitting.value = true;
                              // if (emailController.text ==
                              //     'driver@gmail.com') {
                              //   Navigation.getInstance
                              //       .RightToLeft_PageNavigation(
                              //           context, DriverHomeScreen());
                              // } else {
                              //   Navigation.getInstance
                              //       .RightToLeft_PageNavigation(
                              //           context, UserHomeScreen());
                              // }
                              // await AppService.getInstance.login(
                              //     context,
                              //     emailController.text,
                              //     PasswordController.text);
                              // Navigation.getInstance
                              //     .RightToLeft_PageNavigation(
                              //         context,
                              //         otpVerificationScreen(
                              //             email: emailController
                              //                 .text,
                              //             type:
                              //                 'forgetpassword'));

                              if (type == 'forgetpassword') {
                                Navigation.getInstance
                                    .RightToLeft_PageNavigation(
                                        context, SetNewPasswordScreen());
                              } else {
                                Navigation.getInstance
                                    .pagePushAndReplaceNavigation(
                                        context, BottomNavBar());
                              }
                              apihitting.value = false;
                            } else {
                              FlutterToastDisplay.getInstance
                                  .showToast("Please check your internet");
                            }
                          }
                        },
                      )),
                ),
              ),
            ),
          );
        });
  }
}
