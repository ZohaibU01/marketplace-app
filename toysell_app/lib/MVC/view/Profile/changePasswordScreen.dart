import 'dart:io';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/flutter_toast.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:toysell_app/helper/internet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePsswordScreen extends StatelessWidget {
  ChangePsswordScreen({super.key});

  final internetController = Get.put(InternetController());
  final getcontroller = Get.put(GetxControllersProvider());
  File? selectedImage;
  final oldPasswordcontroller = TextEditingController();
  final NewPasswordcontroller = TextEditingController();
  final ConfirmPasswordcontroller = TextEditingController();
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _NewPasswordFocusNode = FocusNode();
  final FocusNode _ConfirmPasswordFocusNode = FocusNode();

  RxBool apihitting = false.obs;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
          value: themecontroller.systemUiOverlayStyleForwhite,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: themecontroller.backgoundcolor,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                  backgroundColor: themecontroller.backgoundcolor,
                  title: Text(
                    'Change Password',
                    style: TextStyle(
                        color: themecontroller.colorPrimaryBlue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.sp),
                  )),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.screenPadding,
                    vertical: Constants.screenPadding),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 250.sp,
                        width: 250.sp,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/changePass.png'))),
                      ),
                      CustomTextFieldWidget(
                        controller: oldPasswordcontroller,
                        hintText: '',
                        inputType: TextInputType.name,
                        onsubmit: () {},
                        TextColor: Colors.black,
                        focusNode: _oldPasswordFocusNode,
                        label: 'Enter you old Password',
                        validator: (value) {
                          if (value == '') {
                            return 'Please Enter The Updated Name';
                          }
                          return null;
                        },
                        enabled: true,
                      ),
                      SizedBox(height: 10.sp,),
                      CustomTextFieldWidget(
                        controller: NewPasswordcontroller,
                        hintText: '',
                        inputType: TextInputType.name,
                        onsubmit: () {},
                        TextColor: Colors.black,
                        focusNode: _NewPasswordFocusNode,
                        label: 'Enter New Password',
                        validator: (value) {
                          if (value == '') {
                            return 'Please Enter The Updated Name';
                          }
                          return null;
                        },
                        enabled: true,
                      ),
                      SizedBox(height: 10.sp,),
                      CustomTextFieldWidget(
                        controller: ConfirmPasswordcontroller,
                        hintText: '',
                        inputType: TextInputType.name,
                        onsubmit: () {},
                        TextColor: Colors.black,
                        focusNode: _ConfirmPasswordFocusNode,
                        label: 'Enter Password to Confirm',
                        enabled: true,
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(Constants.screenPadding),
                child: Obx(
                  () => RoundButton(
                      height: 45.sp,
                      title: 'Change Password',
                      loading: apihitting.value,
                      disabled: apihitting.value,
                      margin: 0,
                      textColor: Colors.white,
                      backgroundColor: themecontroller.colorPrimaryBlue,
                      borderColor: themecontroller.colorPrimaryBlue,
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          if (NewPasswordcontroller.text ==
                              ConfirmPasswordcontroller.text) {
                            apihitting.value = true;
                            // await AppService.getInstance.updatePassword(
                            //     context,
                            //     NewPasswordcontroller.text,
                            //     oldPasswordcontroller.text);
                            apihitting.value = false;
                          } else {
                            FlutterToastDisplay.getInstance
                                .showToast("Password does'nt match");
                          }
                        }
                        apihitting.value = false;
                      }),
                ),
              ),
            ),
          ));
    });
  }
}
