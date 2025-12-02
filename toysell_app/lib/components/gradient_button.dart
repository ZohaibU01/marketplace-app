import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/theme.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final TextStyle? textStyle;
  final Color? gradientColor;

  final themeHelper = Get.find<ThemeHelper>();

  GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 128.32,
    this.height = 46.0,
    this.textStyle,
    this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    var gradientColor = this.gradientColor ?? themeHelper.colorPrimary;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(1.00, 0.00),
            end: const Alignment(-1, 0),
            colors: [
              gradientColor.withValues(alpha: 1),
              gradientColor.withValues(alpha: 1),
              gradientColor.withValues(alpha: 0.8),
              gradientColor.withValues(alpha: 0.1),
            ].reversed.toList(),
            stops: const [
              0,0.35,0.9,1
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.49),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
