import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeHelper extends GetxController {
  RxBool isDarkTheme = false.obs;

  static const colortoast = Color.fromARGB(255, 88, 156, 253);
  static const colortoasttext = Color(0xffffffff);

  final colorPrimary = HexColor('#B1C7B0');
  final colorPrimaryBlue = HexColor('#3498DB');

  final greenheadingColor = HexColor('#14ae5c');
  final colorCanvas = const Color(0xFFfecdca);

  final pink = const Color(0xFFFFE4D1);

  final greyColor = const Color(0xFFB5B5B5);

  final redColor = Colors.red;

  final circleicon = const Color(0xfffd853a);
  final circlecolor = const Color(0xffFFEAD5);
  final disablecolor = const Color(0xff475467);

  final textFieldBorderColor = const Color(0xFFFF9E59);

  final bottomiconcolor = const Color(0xff475467);
  final bordercolor = const Color.fromARGB(255, 231, 231, 231);
  final colorIcon = Colors.black;
  final textfiledecolor = const Color.fromARGB(255, 255, 255, 255);

  final nutrientsecolor = const Color.fromARGB(255, 244, 244, 245);
  final textcolor = const Color(0xff101828);

  final textcolor2 = const Color(0xff101828).withOpacity(0.5);

  final cardcolor = const Color(0xfff2f4f7);

  final backgoundcolor = const Color.fromARGB(255, 255, 255, 255);
  final bgcolor = const Color(0xfff2f4f7);
  final bgcolor2 = const Color(0xffF6F2F1);
  final lightcolor = const Color(0xfff2f4f7);
  final colorwhite = const Color(0xffffffff);

  //Snackbar colors
  Color get errorColor => Colors.red; // Example
  Color get textOnErrorColor => Colors.white;
  Color get successColor => Colors.green; // Example
  Color get textOnSuccessColor => Colors.white;
  Color get infoColor => Colors.blueAccent; // Example
  Color get textOnInfoColor => Colors.white;




  final notificationbottomsheetGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 48, 128, 240),
      Color.fromARGB(255, 80, 151, 250),
      Color.fromARGB(255, 91, 154, 242),
      Color.fromRGBO(63, 77, 141, 1),
      Color.fromRGBO(60, 94, 141, 1),
      Color.fromRGBO(66, 102, 153, 1),
      Color.fromRGBO(58, 110, 142, 1),
      Color.fromRGBO(55, 125, 142, 1),
      Color.fromRGBO(53, 129, 141, 1),
    ],
    // stops: [
    //   0.1,
    //   0.4,
    //   0.6,
    //   0.9,
    //   0.4,
    //   0.6,
    // ],
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
  );

  final containerGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 255, 228, 210),
      Color.fromARGB(255, 253, 240, 231),
      Color.fromARGB(255, 255, 241, 241),
      Color.fromARGB(255, 253, 240, 231),
      Color.fromARGB(255, 255, 241, 241),
      Color.fromARGB(255, 253, 241, 232),
    ],
    stops: [
      0.1,
      0.4,
      0.6,
      0.9,
      0.4,
      0.6,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final screenGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 88, 156, 253),
      Color.fromARGB(255, 88, 156, 253),
      Color.fromARGB(255, 137, 157, 247),
      Color.fromARGB(255, 253, 240, 231),
      Color.fromARGB(255, 255, 241, 241),
      Color.fromARGB(255, 253, 241, 232),
    ],
    stops: [
      0.7,
      0.5,
      0.3,
      0.2,
      0.1,
      0.0,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final bottomsheetGradient = const LinearGradient(
    colors: [
      // Color.fromARGB(255, 248, 237, 208),

      Color(0xffFFF7E5),
      Color(0xffFFF7E5),
      Color.fromARGB(255, 253, 250, 243),

      Color.fromARGB(255, 252, 249, 244),
      Color.fromARGB(255, 253, 251, 245),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),

      // Color(0xffFEF7F7),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      // Color(0xffFEF7F7),

      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
      Color(0xffFFFFFF),
    ],
    transform: GradientRotation(20 / 13),
    tileMode: TileMode.clamp,
    // stops: [
    //   0.8,
    //   0.4,
    //   0.1,
    //   0.9,
    //   0.6,
    //   0.1,
    // ],
    // begin: Alignment(1.1, 0.0),
    // end: Alignment.bottomRight,
  );

  final backgroundGradient = const LinearGradient(
          colors: [Color(0xffcedece), Color(0xffb1c7b0), Color(0xffb1c7b0)],
          stops: [0.2, 0.75, 0.93],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        )
      ;
      

  SystemUiOverlayStyle get systemUiOverlayStyleMain => SystemUiOverlayStyle(
        statusBarColor: const Color(0xffffffff),
        systemNavigationBarColor: const Color(0xffffffff),
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );

  SystemUiOverlayStyle get systemUiOverlayStyleforwhiteandtarnsparent =>
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );
  SystemUiOverlayStyle get systemUiOverlayStyleForBlack => SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );

  SystemUiOverlayStyle get systemUiOverlayStyleForPrimary =>
      SystemUiOverlayStyle(
        statusBarColor: const Color(0xff85a4e7),
        systemNavigationBarColor: const Color(0xffffffff),
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );
  SystemUiOverlayStyle get systemUiOverlayStylesplash => SystemUiOverlayStyle(
        statusBarColor: const Color.fromARGB(255, 248, 94, 86),
        systemNavigationBarColor: const Color.fromARGB(255, 248, 105, 110),
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );

  SystemUiOverlayStyle get systemUiOverlayStyleForwelcomeScreen =>
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );
  SystemUiOverlayStyle get systemUiOverlayStyleForwhite => SystemUiOverlayStyle(
        statusBarColor:  Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );

SystemUiOverlayStyle get systemUiOverlayStylefortarnsparent => SystemUiOverlayStyle(
        statusBarColor:  Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );

  SystemUiOverlayStyle get systemUiOverlayStyleForGradient =>
      SystemUiOverlayStyle(
        statusBarColor: const Color.fromARGB(255, 0, 0, 0),
        systemNavigationBarColor: const Color(0xffffffff),
        statusBarBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            isDarkTheme.value ? Brightness.dark : Brightness.light,
      );
}
