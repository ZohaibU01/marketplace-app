import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../constant/theme.dart';

class SmallLoader extends StatelessWidget {
  const SmallLoader({
    super.key,
    this.adaptive = false,
    this.color,
  });
  final bool adaptive;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    // var darkThemeProvider = Provider.of<DarkThemeProvider>(context);
    final themeController = Get.put(ThemeHelper());
    return adaptive
        ? Platform.isIOS
            ? CupertinoActivityIndicator(
                color: color ?? themeController.colorPrimary,
              )
            : SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? themeController.colorPrimary,
                  ),
                ),
              )
        : Center(
            child: SpinKitWanderingCubes(
              color: themeController.colorPrimary,
              size: 20,
            ),
          );
  }
}
