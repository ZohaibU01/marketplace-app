import 'package:toysell_app/MVC/view/loginScreen/UserRegisterationScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/forgetPasswordScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/otpVerificationScreen.dart';
import 'package:toysell_app/components/OtpfieldWidget.dart';
import 'package:toysell_app/components/logintextfield.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import '../../../components/round_button.dart';
import '../../../constant/flutter_toast.dart';
import '../../../helper/internet_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final internetController = Get.put(InternetController());
  final getxcontroller = Get.put(GetxControllersProvider());
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final otpController = TextEditingController();
  RxBool showPassword = true.obs;
  final FocusNode _EmailFocusNode = FocusNode();
  final FocusNode _PasswordFocusNode = FocusNode();

  RxBool apihitting = false.obs;

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
                                        'Forgot password?',
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
                                        'No worries, we’ll send you reset \ninstructions',
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
                                loginTextFieldWidget(
                                  enabled: true,
                                  label: '',
                                  controller: emailController,
                                  hintText: "Email address",
                                  inputType: TextInputType.emailAddress,
                                  focusNode: _EmailFocusNode,
                                  onchange: (value) {
                                    apihitting.value = false;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email address';
                                    }
                                    const emailPattern =
                                        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$';
                                    if (!RegExp(emailPattern).hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15.sp),
                                Obx(() => RoundButton(
                                      gradient: false,
                                      margin: 0,
                                      backgroundColor: Colors.white,
                                      height: 45.sp,
                                      borderRadius: 10.sp,
                                      loading: apihitting.value,
                                      disabled: apihitting.value,
                                      title: 'Send OTP',
                                      borderColor: Colors.white,
                                      borderWidth: 1.sp,
                                      iconColor: themecontroller.colorwhite,
                                      textColor: Colors.black.withOpacity(0.5),
                                      onTap: () async {
                                        await internetController
                                            .internetCheckerFun();

                                        if (_formkey.currentState!.validate()) {
                                          if (internetController
                                                  .isInternetConnected.value ==
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
                                            Navigation.getInstance
                                                .RightToLeft_PageNavigation(
                                                    context,
                                                    otpVerificationScreen(
                                                        email: emailController
                                                            .text,
                                                        type:
                                                            'forgetpassword'));
                                            apihitting.value = false;
                                          } else {
                                            FlutterToastDisplay.getInstance
                                                .showToast(
                                                    "Please check your internet");
                                          }
                                        }
                                      },
                                    )),
                              ],
                            ),
                          ),
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
