import 'package:toysell_app/MVC/view/loginScreen/SignInScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/forgetPasswordScreen.dart';
import 'package:toysell_app/components/logintextfield.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import '../../../components/round_button.dart';
import '../../../constant/flutter_toast.dart';
import '../../../helper/internet_controller.dart';

class SetNewPasswordScreen extends StatelessWidget {
  SetNewPasswordScreen({super.key});

  final internetController = Get.put(InternetController());
  final _formkey = GlobalKey<FormState>();

  final confirmController = TextEditingController();
  final PasswordController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showConfirmPassword = true.obs;
  final FocusNode _ConfirmPasswordFocusNode = FocusNode();
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
                            child: SingleChildScrollView(
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
                                          'Set New Password',
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
                                          'Set new password so you \ncan login',
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
                                  Obx(() => loginTextFieldWidget(
                                        enabled: true,
                                        label: '',
                                        controller: PasswordController,
                                        hintText: "Password",
                                        inputType: TextInputType.visiblePassword,
                                        obscureText: showPassword.value,
                                        focusNode: _PasswordFocusNode,
                                        onchange: (value) {
                                          apihitting.value = false;
                                        },
                                        validator: (input) => input!.length < 3
                                            ? 'Please enter at least 3 characters'
                                            : input.length > 20
                                                ? 'Please enter only 20 characters'
                                                : null,
                                        suffixIcon: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            showPassword.value =
                                                !showPassword.value;
                                          },
                                          child: Icon(
                                            showPassword.value
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Obx(() => loginTextFieldWidget(
                                        enabled: true,
                                        label: '',
                                        controller: confirmController,
                                        hintText: "Confirm Password",
                                        inputType: TextInputType.visiblePassword,
                                        obscureText: showConfirmPassword.value,
                                        focusNode: _ConfirmPasswordFocusNode,
                                        onchange: (value) {
                                          apihitting.value = false;
                                        },
                                        validator: (input) => input!.length < 3
                                            ? 'Please enter at least 3 characters'
                                            : input.length > 20
                                                ? 'Please enter only 20 characters'
                                                : null,
                                        suffixIcon: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            showConfirmPassword.value =
                                                !showConfirmPassword.value;
                                          },
                                          child: Icon(
                                            showConfirmPassword.value
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 30.sp),
                                  Obx(() => RoundButton(
                                        gradient: false,
                                        margin: 0,
                                        backgroundColor: Colors.white,
                                        height: 45.sp,
                                        borderRadius: 10.sp,
                                        loading: apihitting.value,
                                        disabled: apihitting.value,
                                        title: 'Set New Password',
                                        borderColor: Colors.white,
                                        borderWidth: 1.sp,
                                        iconColor: themecontroller.colorwhite,
                                        textColor: Colors.black.withOpacity(0.5),
                                        onTap: () async {
                                          await internetController
                                              .internetCheckerFun();
                              
                                          if (_formkey.currentState!.validate()) {
                                            if (confirmController.text ==
                                                PasswordController.text) {
                                              if (internetController
                                                      .isInternetConnected
                                                      .value ==
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
                                                    .pagePushAndReplaceNavigation(
                                                        context, SignInScreen());
                              
                                                apihitting.value = false;
                                              } else {
                                                FlutterToastDisplay.getInstance
                                                    .showToast(
                                                        "Please check your internet");
                                              }
                                            } else {
                                              FlutterToastDisplay.getInstance
                                                  .showToast(
                                                      "Password doesnot match");
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
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
