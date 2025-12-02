import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/view/loginScreen/signupScreen.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/components/spring_widget.dart';
import '../../../components/round_button.dart';
import '../../../constant/navigation.dart';
import '../../../constant/theme.dart';
import '../../controller/login_controller.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  String? validateEmail(String? input) {
    if (input == null || input.isEmpty) {
      return "email_required".tr;
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(input)) {
      return "valid_email".tr;
    }
    return null;
  }

  String? validatePassword(String? input) {
    if (input == null || input.isEmpty) {
      return "password_required".tr;
    }
    if (input.length < 8) {
      return "password_min_length".tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeHelper = Get.find<ThemeHelper>();

    return Scaffold(
      backgroundColor: themeHelper.bgcolor,
      appBar: AppBar(
        backgroundColor: themeHelper.bgcolor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'sign_in'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Obx(
              () => SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.sp),
                  Text(
                    "welcome_back".tr,
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: themeHelper.textcolor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 8.sp),
                  Text(
                    "sign_in_to_continue".tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: themeHelper.textcolor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  // Email Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "email_hint".tr,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 12.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: validateEmail,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Poppins",
                      color: themeHelper.textcolor,
                    ),
                  ),
                  SizedBox(height: 16.sp),
                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "password_hint".tr,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 12.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: validatePassword,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Poppins",
                      color: themeHelper.textcolor,
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  // Sign In Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.sp),
                    child: RoundButton(
                      height: 44.sp,
                      gradient: true,
                      borderRadius: 30.sp,
                      title: 'continue'.tr,
                      textColor: Colors.black.withOpacity(0.5),
                      loading: loginController.isLoading.value,
                      onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          var result = await loginController.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (result) {
                            Navigation.getInstance.pagePushAndReplaceNavigation(
                                context, const BottomNavBar());
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  // Don't have an account? Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "dont_have_account".tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeHelper.textcolor.withOpacity(0.6),
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(width: 4.sp),
                      SpringWidget(
                        onTap: () {
                          Navigation.getInstance.RightToLeft_PageNavigation(
                            context,
                            SignupScreen(),
                          );
                        },
                        child: Text(
                          "sign_up".tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: themeHelper.colorPrimary,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

