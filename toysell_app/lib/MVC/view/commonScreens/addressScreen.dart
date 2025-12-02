import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/theme.dart';
import '../../../constant/constants.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeHelper>();

    return Scaffold(
      backgroundColor: themeController.backgoundcolor,
      appBar: AppBar(
        backgroundColor: themeController.backgoundcolor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: themeController.textcolor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Manage Address",
          style: TextStyle(
            color: themeController.textcolor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.screenPadding),
        child: Column(
          children: [
            SizedBox(height: 20.sp),
            _buildAddressCard(
              themeController: themeController,
              icon: Icons.home_outlined,
              label: "My Home",
            ),
            SizedBox(height: 10.sp),
            _buildAddressCard(
              themeController: themeController,
              icon: Icons.apartment_outlined,
              label: "My Office",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeController.colorPrimary,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Handle Add Address Action
        },
      ),
    );
  }

  Widget _buildAddressCard({
    required ThemeHelper themeController,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: themeController.greyColor, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.sp,
            backgroundColor: themeController.colorPrimary.withOpacity(0.1),
            child: Icon(icon, color: themeController.colorPrimary),
          ),
          SizedBox(width: 10.sp),
          Text(
            label,
            style: TextStyle(
              color: themeController.textcolor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
