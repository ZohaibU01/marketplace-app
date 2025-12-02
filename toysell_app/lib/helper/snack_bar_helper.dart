import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/theme.dart';

class SnackbarHelper {
  static final themeHelper = Get.find<ThemeHelper>();

  // Method to show an error snackbar
  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: themeHelper.errorColor, // Error color from ThemeHelper
      colorText: themeHelper.textOnErrorColor, // Text color on error background
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // Method to show a success snackbar
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: themeHelper.successColor, // Success color from ThemeHelper
      colorText: themeHelper.textOnSuccessColor, // Text color on success background
      duration: const Duration(seconds: 3),
    );
  }

  // Additional method for info snackbars if needed
  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: themeHelper.infoColor, // Info color from ThemeHelper
      colorText: themeHelper.textOnInfoColor, // Text color on info background
      duration: const Duration(seconds: 3),
    );
  }
}
