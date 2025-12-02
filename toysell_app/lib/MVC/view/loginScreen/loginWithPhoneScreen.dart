import 'package:toysell_app/MVC/view/loginScreen/otpVerificationScreen.dart';
import 'package:toysell_app/components/logintextfield.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import '../../../components/round_button.dart';
import '../../../constant/flutter_toast.dart';
import '../../../helper/internet_controller.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class loginwithPhoneScreen extends StatefulWidget {
  const loginwithPhoneScreen({super.key});

  @override
  State<loginwithPhoneScreen> createState() => _loginwithPhoneScreenState();
}

class _loginwithPhoneScreenState extends State<loginwithPhoneScreen> {
  final internetController = Get.put(InternetController());

  final getxcontroller = Get.put(GetxControllersProvider());

  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final otpController = TextEditingController();

  RxBool showPassword = true.obs;

  final FocusNode _EmailFocusNode = FocusNode();

  final FocusNode _PasswordFocusNode = FocusNode();

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');
  // Default country: US
  final TextEditingController _controller = TextEditingController();

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
                                          'Enter mobile Number',
                                          maxLines: 1,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              fontSize: 25.sp,
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
                                          "Add your phone number. We'll send you a verification code\nso we know you're real.",
                                          softWrap: true,
                                          maxLines: 3,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50.sp,
                                  ),
                                  InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {
                                      setState(() {
                                        _phoneNumber = number;
                                      });
                                    },
                                    onInputValidated: (bool value) {
                                      // You can add your validation logic here
                                      print('Is valid: $value');
                                    },
                                    textStyle: const TextStyle(color: Colors.white),
                                    selectorConfig: const SelectorConfig(
                                      selectorType: PhoneInputSelectorType.DIALOG,
                                    ),
                                    textFieldController: _controller,
                                    initialValue: _phoneNumber,
                                    inputDecoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      border: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.white,
                                      )),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.sp)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.sp)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.sp)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red.withOpacity(0.2),
                                              width: 1.sp)),
                                    ),
                                  ),
                                  SizedBox(height: 20.sp),
                                  Obx(() => RoundButton(
                                        gradient: false,
                                        margin: 0,
                                        backgroundColor: Colors.white,
                                        height: 45.sp,
                                        borderRadius: 10.sp,
                                        loading: apihitting.value,
                                        disabled: apihitting.value,
                                        title: 'Confirm',
                                        borderColor: Colors.white,
                                        borderWidth: 1.sp,
                                        iconColor: themecontroller.colorwhite,
                                        textColor: Colors.black.withOpacity(0.5),
                                        onTap: () async {
                                          await internetController
                                              .internetCheckerFun();
                              
                                          // if (_formkey.currentState!.validate()) {
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
                                                        email:
                                                            emailController.text,
                                                        type: 'phone'));
                                            apihitting.value = false;
                                          } else {
                                            FlutterToastDisplay.getInstance
                                                .showToast(
                                                    "Please check your internet");
                                          }
                                          // }
                                        },
                                      )),
                                  SizedBox(
                                    height: 30.sp,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'By signing up you agree to our',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.7),
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Terms',
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' and\n',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.7),
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' we protect your personal data',
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.7),
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
