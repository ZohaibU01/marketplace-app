import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';

import 'small_loader.dart';

class RoundButton extends StatefulWidget {
  const RoundButton({
    super.key,
    required this.height,
    this.width,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.icon,
    required this.title,
    this.iconColor,
    required this.onTap,
    this.margin = 20,
    this.borderColor = Colors.white,
    this.loading = false,
    this.disabled = false,
    this.gradient = false,
    this.borderWidth,
    this.borderRadius,
    this.titleSize,
    this.gapBtWIconAndText,
    this.fontWeight = FontWeight.w600,
    this.loaderColor = Colors.white
  });

  final double height;
  final double? width;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;
  final String title;
  final Color? iconColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final double margin;
  final double? borderWidth;
  final double? titleSize;
  final double? borderRadius;
  final double? gapBtWIconAndText;
  final bool loading;
  final bool disabled;
  final bool gradient;
  final FontWeight fontWeight;
  final Color loaderColor;

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  bool pressed = false;
  final themeController = Get.put(ThemeHelper());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        if (widget.loading || widget.disabled) return;
        setState(() {
          pressed = true;
        });
      },
      onPanEnd: (_) {
        if (widget.loading || widget.disabled) return;
        setState(() {
          pressed = false;
        });
      },
      onPanCancel: () {
        if (widget.loading || widget.disabled) return;
        setState(() {
          pressed = false;
        });
      },
      onTap: () {
        if (widget.loading || widget.disabled) return;
        widget.onTap();
      },
      child: AnimatedOpacity(
        opacity: pressed ? 0.8 : 1,
        duration: const Duration(milliseconds: 250),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.gradient
                ? null
                : widget.disabled
                ? widget.backgroundColor.withOpacity(0.6)
                : widget.backgroundColor,
            gradient:
            widget.gradient ? themeController.backgroundGradient : null,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            border: Border.all(
                color: widget.borderColor!, width: widget.borderWidth ?? 0.3),
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withOpacity(0.1),
                spreadRadius: 1.5,
                blurRadius: 4,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          height: widget.height,
          width: widget.width,
          margin: EdgeInsets.symmetric(horizontal: widget.margin),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null && !widget.loading)
                widget.icon!, // Use the provided widget directly
              if (widget.icon != null && !widget.loading)
                SizedBox(width: widget.gapBtWIconAndText ?? 10),
              if (!widget.loading)
                Text(
                  widget.title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: widget.fontWeight,
                    color: widget.gradient ? Colors.white : widget.textColor,
                    fontSize: widget.titleSize ?? 12.sp,
                  ),
                ),
              if (widget.loading)
                SmallLoader(
                  color: widget.loaderColor,
                  adaptive: true,
                )
            ],
          ),
        ),
      ),
    );
  }
}
