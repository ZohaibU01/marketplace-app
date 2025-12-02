import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/image_picker_bottom_sheet.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';

import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:toysell_app/helper/internet_controller.dart';

import '../../../components/gradient_button.dart';
import '../../controller/forumController.dart';
import '../../model/forum_model.dart';

class AddforumScreen extends StatelessWidget {
  AddforumScreen({super.key, this.forumPost});

  final ForumPost? forumPost;

  final internetController = Get.put(InternetController());
  final getcontroller = Get.put(GetxControllersProvider());
  final forumController = Get.put(ForumController());

  @override
  Widget build(BuildContext context) {
    if (forumPost != null) {
      forumController.descriptionController.text = forumPost!.caption;
      forumController.imagePath.value = forumPost!.imagePath;
      forumController.tags.assignAll(forumPost!.tags.map((tag) => tag.name).toList());
    }

    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return AnnotatedRegion(
          value: themeController.systemUiOverlayStyleForwhite,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: themeController.backgoundcolor,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                surfaceTintColor: themeController.backgoundcolor,
                backgroundColor: themeController.backgoundcolor,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                title: Text(
                  forumPost == null ? 'new_post'.tr : 'edit_post'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.screenPadding,
                  vertical: Constants.screenPadding,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ImagePickerBottomSheet.show(
                            context,
                          ).then((value) {
                            if (getcontroller.imagePath.isNotEmpty) {
                              forumController.imagePath.value = getcontroller.imagePath.value;
                            }
                          });
                        },
                        child: Obx(() => forumController.imagePath.value.isNotEmpty
                            ? Container(
                          height: 150.sp,
                          width: 150.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.sp),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (forumPost?.imagePath != null && forumPost!.imagePath.startsWith("http"))
                                  ? NetworkImage(forumPost!.imagePath)
                                  : FileImage(File(forumController.imagePath.value)),
                            ),
                          ),
                        )
                            : DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(20.sp),
                          strokeWidth: 2.sp,
                          color: themeController.colorPrimary,
                          dashPattern: [10.sp, 6.sp],
                          child: Container(
                            height: 150.sp,
                            width: 150.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.sp),
                            ),
                            child: Center(
                              child: Icon(Icons.add_a_photo,
                                  size: 50.sp, color: themeController.colorPrimary),
                            ),
                          ),
                        )),
                      ),
                      SizedBox(height: 20.sp),
                      Text("description".tr,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 10.sp),
                      CustomTextFieldWidget(
                        controller: forumController.descriptionController,
                        height: 100.sp,
                        maxLines: 5,
                        hintText: 'Enter description here...',
                        onsubmit: () {},
                        inputType: TextInputType.text,
                        label: '',
                        enabled: true,
                      ),
                      SizedBox(height: 20.sp),
                      Text("tags".tr,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 10.sp),
                      Obx(() {
                        return Wrap(
                          spacing: 10.sp,
                          runSpacing: 10.sp,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: forumController.tags.map<Widget>((tag) {
                            return Chip(
                              label: Text(tag),
                              deleteIcon: Icon(Icons.close, size: 12.sp),
                              onDeleted: () {
                                forumController.tags.remove(tag);
                              },
                            );
                          }).toList()
                            ..add(
                              SpringWidget(
                                onTap: () {
                                  _showAddTagDialog(context);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        size: 20.sp, color: themeController.colorPrimary),
                                    SizedBox(width: 5.sp),
                                    Text("add_tag".tr,
                                        style: TextStyle(color: themeController.colorPrimary)),
                                  ],
                                ),
                              ),
                            ),
                        );
                      }),
                      SizedBox(height: 30.sp),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Obx(() {
                return RoundButton(
                  height: 50.sp,
                  gradient: true,
                  borderRadius: 20.sp,
                  title: forumPost == null ? "post_now".tr : "update_post".tr,
                  loading: forumController.isLoading.value,
                  onTap: () {
                    if (forumPost == null) {
                      // Create new post
                      forumController.postForum().then((res) {
                        if (res) {
                          Navigator.pop(context, true);
                        }
                      });
                    } else {
                      // Edit existing post
                      forumController.editForum(forumPost!.id).then((res) {
                        if (res) {
                          Navigator.pop(context, true);
                        }
                      });
                    }
                  },
                );
              }),
            ),
          ));
    });
  }

  void _showAddTagDialog(BuildContext context) {
    final TextEditingController tagController = TextEditingController();
    final themeController = Get.find<ThemeHelper>();

    _showPopup(
      context: context,
      title: "add_tag".tr,
      content: TextField(
        controller: tagController,
        decoration: InputDecoration(
          hintText: 'enter_tags'.tr,
          hintStyle: TextStyle(
            color: themeController.textcolor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      buttonText: "add_tag".tr,
      onButtonPressed: () {
        final input = tagController.text.trim();
        if (input.isNotEmpty) {
          final tags = input.split(' ').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
          forumController.tags.addAll(tags);
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("please_enter_valid_tags".tr)),
          );
        }
      },
    );
  }

  void _showPopup({
    required BuildContext context,
    required String title,
    required Widget content,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    final themeController = Get.find<ThemeHelper>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeController.backgoundcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Container(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeController.colorIcon.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: Icon(Icons.close, size: 20.sp),
                    ),
                  ),
                ),
                SizedBox(height: 10.sp),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: themeController.textcolor,
                  ),
                ),
                SizedBox(height: 10.sp),
                Divider(thickness: 1, color: themeController.colorIcon),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.sp),
                  child: content,
                ),
                GradientButton(
                  label: buttonText,
                  onPressed: onButtonPressed ?? () {},
                ),
                SizedBox(height: 10.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}

class tagsbubble extends StatelessWidget {
  const tagsbubble({
    super.key,
    required this.heading,
  });

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 246, 246),
          borderRadius: BorderRadius.circular(20.sp)),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      child: Text(
        heading,
        style: TextStyle(fontSize: 8.sp),
      ),
    );
  }
}
