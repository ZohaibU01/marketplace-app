import 'package:toysell_app/helper/getx_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import '../../../helper/internet_controller.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});
  final internetController = Get.put(InternetController());
  final getxcontroller = Get.put(GetxControllersProvider());

  final fearController = TextEditingController();
  final FocusNode _fearFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "FAQ's",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: themecontroller.colorPrimary),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(10.sp),
            child: const Column(
              children: [
                Text(
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).")
              ],
            ),
          ));
    });
  }
}
