import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../constant/theme.dart';
import '../../controller/helpcenter_controller.dart';
import '../../model/helpcenter_topic_model.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final helpCenterController = Get.put(HelpCenterController());
  HelpCenterTopic? selectedMainCategory;
  HelpCenterTopic? selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return AnnotatedRegion(
        value: themeController.systemUiOverlayStyleForwhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: themeController.backgoundcolor,
            appBar: AppBar(
              backgroundColor: themeController.backgoundcolor,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  if (selectedSubCategory != null) {
                    setState(() => selectedSubCategory = null);
                  } else if (selectedMainCategory != null) {
                    setState(() => selectedMainCategory = null);
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              automaticallyImplyLeading: false,
              title: Text(
                selectedSubCategory?.topic ??
                    selectedMainCategory?.topic ??
                    'help_center'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.sp,
                ),
              ),
              shadowColor: Colors.transparent,
            ),
            body: Obx(() {
              if (helpCenterController.isLoading.value) {
                return _buildLoadingList();
              }

              if (helpCenterController.topics.isEmpty) {
                return Center(
                  child: Text(
                    'No topics available',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                );
              }

              if (selectedSubCategory != null) {
                return _buildContent(themeController, selectedSubCategory!.content!);
              } else if (selectedMainCategory != null) {
                return _buildSubCategoryList(
                    themeController, selectedMainCategory!.subtopics);
              } else {
                return _buildMainCategoryList(
                    themeController, helpCenterController.topics);
              }
            }),
          ),
        ),
      );
    });
  }

  Widget _buildMainCategoryList(
      ThemeHelper themeController, List<HelpCenterTopic> topics) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Column(
          children: [
            ListTile(
              title: Text(
                topic.topic,
                style: TextStyle(
                  color: themeController.textcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() => selectedMainCategory = topic);
              },
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeController.greyColor,
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubCategoryList(
      ThemeHelper themeController, List<HelpCenterTopic> subtopics) {
    return ListView.builder(
      itemCount: subtopics.length,
      itemBuilder: (context, index) {
        final subtopic = subtopics[index];
        return Column(
          children: [
            ListTile(
              title: Text(
                subtopic.topic,
                style: TextStyle(
                  color: themeController.textcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                if (subtopic.content != null) {
                  setState(() => selectedSubCategory = subtopic);
                }
              },
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: themeController.greyColor,
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(ThemeHelper themeController, String content) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: HtmlWidget(content),
        // Text(
        //   content,
        //   style: TextStyle(
        //     color: themeController.textcolor,
        //     fontSize: 16,
        //     fontWeight: FontWeight.w400,
        //   ),
        // ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [
              Container(
                width: 50.sp,
                height: 50.sp,
                color: Colors.grey.shade300,
              ),
              SizedBox(width: 10.sp),
              Expanded(
                child: Container(
                  height: 20.sp,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
