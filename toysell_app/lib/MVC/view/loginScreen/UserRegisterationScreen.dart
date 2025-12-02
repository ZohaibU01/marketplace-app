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

class UserRegisterationScreen extends StatelessWidget {
  UserRegisterationScreen({super.key});

  final internetController = Get.put(InternetController());
  final getxcontroller = Get.put(GetxControllersProvider());
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showConfirmPassword = true.obs;
  final FocusNode _NameFocusNode = FocusNode();
  final FocusNode _EmailFocusNode = FocusNode();
  final FocusNode _PasswordFocusNode = FocusNode();
  final FocusNode _ConfirmPasswordFocusNode = FocusNode();

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
                        SizedBox(width: 20.sp),
                        Container(
                          height: 150.sp,
                          width: 150.sp,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/logo.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                  .withOpacity(0.9),
                              offset: const Offset(0, 5),
                              blurRadius: 30,
                              spreadRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.sp),
                            topRight: Radius.circular(20.sp),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 20.sp),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 300.sp,
                                      child: Text(
                                        'welcome_back'.tr,
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 300.sp,
                                      child: Text(
                                        'create_account'.tr,
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
                                SizedBox(height: 20.sp),
                                loginTextFieldWidget(
                                  enabled: true,
                                  label: '',
                                  controller: nameController,
                                  hintText: 'fullname'.tr,
                                  inputType: TextInputType.name,
                                  focusNode: _NameFocusNode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'email_required'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.sp),
                                loginTextFieldWidget(
                                  enabled: true,
                                  label: '',
                                  controller: emailController,
                                  hintText: 'email_address'.tr,
                                  inputType: TextInputType.emailAddress,
                                  focusNode: _EmailFocusNode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'email_required'.tr;
                                    }
                                    const emailPattern =
                                        r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,4})$';
                                    if (!RegExp(emailPattern).hasMatch(value)) {
                                      return 'valid_email'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10.sp),
                                Obx(() => loginTextFieldWidget(
                                  enabled: true,
                                  label: '',
                                  controller: PasswordController,
                                  hintText: 'password'.tr,
                                  inputType: TextInputType.visiblePassword,
                                  obscureText: showPassword.value,
                                  focusNode: _PasswordFocusNode,
                                  validator: (input) => input!.length < 3
                                      ? 'password_length_error'.tr
                                      : input.length > 20
                                      ? 'password_length_error_long'.tr
                                      : null,
                                  suffixIcon: GestureDetector(
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
                                SizedBox(height: 10.sp),
                                Obx(() => loginTextFieldWidget(
                                  enabled: true,
                                  label: '',
                                  controller: ConfirmPasswordController,
                                  hintText: 'confirm_password'.tr,
                                  inputType: TextInputType.visiblePassword,
                                  obscureText: showConfirmPassword.value,
                                  focusNode: _ConfirmPasswordFocusNode,
                                  validator: (input) => input!.length < 3
                                      ? 'password_length_error'.tr
                                      : input.length > 20
                                      ? 'password_length_error_long'.tr
                                      : null,
                                  suffixIcon: GestureDetector(
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
                                  title: 'sign_up'.tr,
                                  gradient: false,
                                  height: 45.sp,
                                  borderRadius: 10.sp,
                                  loading: apihitting.value,
                                  onTap: () async {
                                    if (_formkey.currentState!.validate()) {
                                      if (ConfirmPasswordController.text ==
                                          PasswordController.text) {
                                        // Handle sign up logic
                                      } else {
                                        FlutterToastDisplay.getInstance
                                            .showToast(
                                            'password_mismatch'.tr);
                                      }
                                    }
                                  },
                                )),
                                SizedBox(height: 30.sp),
                                GestureDetector(
                                  onTap: () {
                                    Navigation.getInstance.screenNavigation(
                                        context, SignInScreen());
                                  },
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: themecontroller.textcolor
                                            .withOpacity(0.9),
                                        fontSize: 11.sp,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "already_have_account".tr,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' sign_in'.tr,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

