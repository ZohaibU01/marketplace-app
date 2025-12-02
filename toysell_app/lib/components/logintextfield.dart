
import 'package:toysell_app/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class loginTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final TextAlign? textAlign;
  final Widget? suffixIcon;
  final Widget? icon;
  final Color? fieldColor;
  final Color? TextColor;
  final bool? obscureText;
  final int? maxLines;
  final ValueChanged<String>? onchange;
  final Function(String)? onsubmit;
  final TextInputType inputType;
  final FocusNode? focusNode;
  final bool enabled;

  final FormFieldValidator<String>? validator;
  loginTextFieldWidget(
      {super.key,
      required this.controller,
      this.onchange,
      required this.hintText,
      this.validator,
      this.icon,
      this.obscureText = false,
      this.suffixIcon,
      this.onsubmit,
      required this.inputType,
      this.maxLines,
      required this.label,
      this.focusNode,
      required this.enabled,
      this.fieldColor,
      this.textAlign,
      this.TextColor = Colors.white});

  final themecontroller = Get.put(ThemeHelper());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        label == ''
            ? const SizedBox()
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: TextStyle(
                      color: themecontroller.textcolor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp),
                ),
              ),
        SizedBox(
          height: 5.sp,
        ),
        TextFormField(
          textAlign: textAlign ?? TextAlign.start,
          onFieldSubmitted: onsubmit,
          enabled: enabled,
          focusNode: focusNode,
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText!,
          maxLines: maxLines ?? 1,
          style: TextStyle(
            color: TextColor ?? themecontroller.textcolor,
            fontSize: 12.sp,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(r'\s\s+')), // Deny consecutive spaces
            LeadingSpaceTrimmerInputFormatter(), // Custom input formatter to trim leading spaces
          ],
          validator: validator,
          decoration: InputDecoration(
            fillColor: fieldColor ?? themecontroller.colorPrimaryBlue,
            filled: true,
            suffixIcon: suffixIcon,
            prefixIcon: icon,
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
                    color: Colors.red.withOpacity(0.2), width: 1.sp)),
            // ),
            // disabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       width: 2,
            //       color: themecontroller.bordercolor.withOpacity(0.4)),
            //   borderRadius:
            //       BorderRadius.circular(Constants.appTxtFld_borderRadius),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       width: 2,
            //       color: themecontroller.bordercolor.withOpacity(0.4)),
            //   borderRadius:
            //       BorderRadius.circular(Constants.appTxtFld_borderRadius),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       width: 2,
            //       color: themecontroller.bordercolor.withOpacity(0.4)),
            //   borderRadius:
            //       BorderRadius.circular(Constants.appTxtFld_borderRadius),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //       width: 2,
            //       color: themecontroller.bordercolor.withOpacity(0.4)),
            //   borderRadius:
            //       BorderRadius.circular(Constants.appTxtFld_borderRadius),
            // ),
            counterStyle: TextStyle(
              color: themecontroller.textcolor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: TextColor!.withOpacity(0.5) ??
                  themecontroller.textcolor.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

class LeadingSpaceTrimmerInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Trim leading spaces from the text value
    if (newValue.text.startsWith(' ')) {
      final trimmedText = newValue.text.trimLeft();
      return newValue.copyWith(
        text: trimmedText,
        composing: TextRange.collapsed(trimmedText.length),
      );
    }
    return newValue;
  }
}