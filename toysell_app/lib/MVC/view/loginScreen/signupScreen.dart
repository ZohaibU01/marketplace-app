import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/view/loginScreen/SignInScreen.dart';
import '../../../components/BottomNav.dart';
import '../../../components/round_button.dart';
import '../../../constant/navigation.dart';
import '../../../constant/theme.dart';
import '../../controller/login_controller.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final countryPicker = const FlCountryCodePicker();
  CountryCode selectedCountryCode = const CountryCode(
    name: "Sweden",
    code: "SE",
    dialCode: "+46",
  );


  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  String? validateEmailOrPhone(String? input) {
    if (input == null || input.isEmpty) {
      return "email_phone_required".tr;
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    final phoneRegex = RegExp(r"^\d{10,}$");
    if (!emailRegex.hasMatch(input) && !phoneRegex.hasMatch(input)) {
      return "valid_email_phone".tr;
    }
    return null;
  }

  String? validatePassword(String? input) {
    if (input == null || input.isEmpty) {
      return "password_required".tr;
    }
    if (input.length < 8) {
      return "password_length".tr;
    }
    final capitalLetterRegex = RegExp(r"[A-Z]");
    final numberRegex = RegExp(r"[0-9]");
    final specialCharRegex = RegExp(r"[\!\@\#\$\%\^\&\*\(\)\,\.\?]");
    if (!capitalLetterRegex.hasMatch(input)) {
      return "password_capital_letter".tr;
    }
    if (!numberRegex.hasMatch(input)) {
      return "password_number".tr;
    }
    if (!specialCharRegex.hasMatch(input)) {
      return "password_special_char".tr;
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
            Navigation.getInstance.pagePushAndReplaceNavigation(context, SignInScreen());
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          'signup'.tr,
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
                    "welcome".tr,
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: themeHelper.textcolor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 8.sp),
                  Text(
                    "sign_up".tr,
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
                      hintText: "email_or_phone".tr,
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
                    validator: validateEmailOrPhone,
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
                      hintText: "password".tr,
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
                  SizedBox(height: 16.sp),
                  // Confirm Password Field
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: isConfirmPasswordHidden,
                    decoration: InputDecoration(
                      hintText: "confirm_password".tr,
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
                          isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordHidden = !isConfirmPasswordHidden;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "confirm_password_required".tr;
                      }
                      if (value != passwordController.text) {
                        return "password_mismatch".tr;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: "Poppins",
                      color: themeHelper.textcolor,
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(12.sp),
                  //     border: Border.all(color: Colors.grey.shade300),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         selectedCountryCode.dialCode,
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           fontFamily: "Poppins",
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       const Icon(Icons.lock, size: 16, color: Colors.grey),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 16.sp),

                  // Signup Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.sp),
                    child: RoundButton(
                      height: 44.sp,
                      gradient: true,
                      borderRadius: 30.sp,
                      title: 'continue'.tr,
                      textColor: Colors.black.withOpacity(0.5),
                      loading: loginController.isLoading.value,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          loginController.signup(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            countryCode: selectedCountryCode.dialCode.replaceAll('+', ''),
                          ).then((value) {
                            if (value) {
                              Navigation.getInstance.pagePushAndReplaceNavigation(
                                context,
                                const BottomNavBar(),
                              );
                            }
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  // Already have an account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already_have_account".tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeHelper.textcolor.withOpacity(0.6),
                          fontFamily: "Poppins",
                        ),
                      ),
                      SizedBox(width: 4.sp),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "sign_in".tr,
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
