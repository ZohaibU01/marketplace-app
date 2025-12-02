import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/controller/SellsController.dart';
import 'package:toysell_app/MVC/view/commonScreens/productDetailScreen.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/image_picker_bottom_sheet.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/product_card.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/data/mockData.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:toysell_app/helper/internet_controller.dart';

class Notificationscreen extends StatelessWidget {
  Notificationscreen({super.key});

  final internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
          value: themecontroller.systemUiOverlayStyleForwhite,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: themecontroller.backgoundcolor,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                  surfaceTintColor: themecontroller.backgoundcolor,
                  backgroundColor: themecontroller.backgoundcolor,
                  centerTitle: true,
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.sp),
                  )),
              body: ListView.builder(
                itemCount: MockData.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.sp),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40.sp,
                                width: 40.sp,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      AssetPaths.appIcon,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200.sp,
                                    child: Text(
                                      "Are you hesitating? Deals....",
                                      maxLines: 1,
                                      softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    width: 200.sp,
                                    child: Text("Browse Classifieds for Unbeatable Offers and More!",
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black.withOpacity(0.3),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ));
    });
  }
}
