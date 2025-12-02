import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import '../constant/constants.dart';
import 'spring_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, 
    //Key? key,
    required this.Title,
    this.leading,
    this.Ontapleading,
    required this.showShop,
    this.backgroundColor,
    this.titleColor,
    this.leadingColor,
  });

  final String Title;
  final IconData? leading;
  final bool showShop;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? leadingColor;
  final Function()? Ontapleading;
  final themecontroller = Get.put(ThemeHelper());
  // final homecontroller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeHelper());

    return AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor ?? themeController.bgcolor,
      centerTitle: true,
      leading: GestureDetector(
        onTap: Ontapleading ??
            () {
              Scaffold.of(context).openDrawer();
            },
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
          child: Icon(
            leading ?? Icons.menu,
            color: leadingColor ?? themecontroller.colorPrimary,
            size: 25.sp,
          ),
        ),
      ),
      title: Text(
        Title,
        style: TextStyle(
            color: titleColor ?? themeController.textcolor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600),
      ),
      actions: [
        showShop == true
            ? SpringWidget(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.sp, horizontal: Constants.screenPadding),
                  child: Obx(
                    () => Badge(
                      backgroundColor: themeController.colorPrimary,
                      label: const Text('2'),
                      child: SvgPicture.asset(
                        'assets/icons/shop.svg',
                        color: leadingColor ?? themeController.colorPrimary,
                        height: 20.sp,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.sp);
}
