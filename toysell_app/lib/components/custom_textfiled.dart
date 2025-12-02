import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final Widget? suffixIcon;
  final Widget? icon;
  final Color? fieldColor;
  final Color? TextColor;
  final double? borderRadius;
  final bool? obscureText;
  final int? maxLines;
  final ValueChanged<String>? onchange;
  final VoidCallback onsubmit;
  final TextInputType inputType;
  final FocusNode? focusNode;
  final bool enabled;
  final double? height;

  final FormFieldValidator<String>? validator;
  CustomTextFieldWidget(
      {super.key,
      required this.controller,
      this.onchange,
      required this.hintText,
      this.validator,
      this.icon,
      this.obscureText = false,
      this.suffixIcon,
      required this.onsubmit,
      required this.inputType,
      this.maxLines,
      required this.label,
      this.focusNode,
      required this.enabled,
      this.fieldColor,
      this.TextColor,
      this.borderRadius,
      this.height});

  final themecontroller = Get.put(ThemeHelper());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55.sp,
      child: Center(
        child: TextFormField(
          onChanged: onchange,
          enabled: enabled,
          focusNode: focusNode,
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText!,
          maxLines: maxLines ?? 1,
          style: TextStyle(
            color: TextColor ?? themecontroller.textcolor,
            fontSize: 10.sp,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(r'\s\s+')), // Deny consecutive spaces
            LeadingSpaceTrimmerInputFormatter(), // Custom input formatter to trim leading spaces
          ],
          validator: validator,
          decoration: InputDecoration(
            // labelText: label,
            // labelStyle: TextStyle(
            //     fontSize: 10.sp, color: Colors.black.withOpacity(0.5)),
            contentPadding: EdgeInsets.symmetric(
                vertical: 15.sp, horizontal: 10.sp), // Adjust vertical padding

            fillColor: fieldColor ?? themecontroller.textfiledecolor,
            filled: true,
            suffixIcon: suffixIcon,
            prefixIcon: icon,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: fieldColor ?? Colors.black.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: fieldColor ??
                      Colors.black.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: fieldColor ??
                      Colors.black.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: fieldColor ??
                      Colors.black.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: fieldColor ??
                      Colors.black.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: fieldColor ??
                      themecontroller.bordercolor.withOpacity(0.8)),
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
            counterStyle: TextStyle(
              color: themecontroller.textcolor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: TextColor ?? themecontroller.textcolor.withOpacity(0.5),
            ),
          ),
        ),
      ),
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
