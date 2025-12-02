import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/constant/theme.dart';

import '../components/gradient_button.dart';

class PopupHelper {
  /// General method to show a popup
  static void showPopup({
    required BuildContext context,
    required String title,
    required Widget content,
    required String buttonText,
    VoidCallback? onButtonPressed,
    bool showCloseButton = true,
    Color? gradientColor
  }) {
    final themeHelper = Get.find<ThemeHelper>();
    var buttonColor = gradientColor ?? themeHelper.colorPrimary;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeHelper.backgoundcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(37),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title and Close Button
                if (showCloseButton)
                  ...[
                    Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: themeHelper.colorIcon.withValues(alpha: 0.12),
                            borderRadius: const BorderRadius.all(Radius.circular(3.0))
                          ),
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ),
                    ],
                  ),
                    SizedBox(height: 24.sp),
                  ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: themeHelper.textcolor,
                  ),
                ),
                SizedBox(height: 3.sp),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(thickness: 1, color: themeHelper.colorIcon),
                ),
                const SizedBox(height: 16),
                // Content
                content,
                SizedBox(height: 36.sp),
                // Button
                GradientButton(
                  label: buttonText,
                  onPressed: onButtonPressed ?? (){},
                  gradientColor: buttonColor,
                ),
                SizedBox(height: 16.sp),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Static method for "Offer Popup"
  static void showOfferPopup({
    required BuildContext context,
    required double sellerPrice,
    required Function(double) onSend,
  }) {
    final TextEditingController controller = TextEditingController();
    final themeHelper = Get.find<ThemeHelper>();

    showPopup(
      context: context,
      title: "Make an offer",
      content: Column(
        children: [
          SizedBox(height: 24.sp),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Seller’s Price',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6100000143051147),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0.05,
                  ),
                ),
                TextSpan(
                  text: ' \$$sellerPrice',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0.05,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.sp),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              width: 260.sp,
              height: 46,
              decoration: ShapeDecoration(
                // gradient: LinearGradient(
                //   begin: const Alignment(1.00, 0.00),
                //   end: const Alignment(-1, 0),
                //   colors: [
                //     themeHelper.colorPrimary.withValues(alpha: 1),
                //     themeHelper.colorPrimary.withValues(alpha: 1),
                //     themeHelper.colorPrimary.withValues(alpha: 0.6),
                //     themeHelper.colorPrimary.withValues(alpha: 0.1),
                //   ].reversed.toList(),
                //   stops: const [
                //     0,0.35,0.69,1
                //   ],
                // ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: themeHelper.colorPrimary),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center, // Center the hint text
                decoration: InputDecoration(
                  hintText: "Your Offer",
                  hintStyle: TextStyle(
                    color: themeHelper.textcolor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide.none, // Remove default border
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              )
            ),
          ),
        ],
      ),
      buttonText: "Send",
      onButtonPressed: () {
        final offer = double.tryParse(controller.text.trim());
        if (offer != null) {
          onSend(offer);
        } else {
          // Optionally show an error if input is invalid
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a valid offer.")),
          );
        }
      },
    );
  }

  /// Static method for "Category Popup"
  static void showCategoryPopup({
    required BuildContext context,
    required Function(String) onRequestToAdd,
  }) {
    final TextEditingController controller = TextEditingController();

    showPopup(
      context: context,
      title: "Category",
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Type Category Here",
          filled: true,
          fillColor: Colors.orange.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepOrange),
          ),
        ),
      ),
      buttonText: "Request to Add",
      onButtonPressed: () {
        final category = controller.text.trim();
        if (category.isNotEmpty) {
          onRequestToAdd(category);
        } else {
          // Optionally show an error if input is invalid
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter a category.")),
          );
        }
      },
    );
  }
}
