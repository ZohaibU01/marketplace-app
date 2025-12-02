import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/SellsController.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/MVC/view/commonScreens/productDetailScreen.dart';
import 'package:toysell_app/MVC/view/forums/addForums.dart';
import 'package:toysell_app/MVC/view/forums/forumDetailScreen.dart';
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
import 'package:toysell_app/helper/data_storage.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:toysell_app/helper/internet_controller.dart';

import '../../controller/forumController.dart';
import '../../controller/tag_bubble.dart';
import '../../model/forum_model.dart';
import '../home/likePostScreen.dart';

class LikedForumPostScreen extends StatelessWidget {
  LikedForumPostScreen({super.key});

  final forumController = Get.put(ForumController()..fetchForumPosts());
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              automaticallyImplyLeading: false,
              title: Text(
                'liked_post'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.sp,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: forumController.fetchForumPosts,
              child: Obx(() {
                if (forumController.isLoading.value) {
                  return _buildShimmerList();
                }

                if (forumController.getLikedForumPost.isEmpty) {
                  return Center(
                    child: Text(
                      "No posts available",
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: forumController.getLikedForumPost.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = forumController.getLikedForumPost[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ForumsCard(data: post,forumController: forumController ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer placeholders
      itemBuilder: (BuildContext context, int index) {
        return _buildShimmerCard();
      },
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                height: 100.sp,
                width: 100.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20.sp,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 10.sp),
                    Container(
                      height: 15.sp,
                      width: 150.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 10.sp),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10.sp,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        SizedBox(width: 5.sp),
                        Container(
                          height: 10.sp,
                          width: 50.sp,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForumsCard extends StatelessWidget {
  const ForumsCard({
    super.key,
    required this.data, required this.forumController,
  });

  final ForumPost data;
  final ForumController forumController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpringWidget(
              onTap: () {
                Navigation.getInstance.bottomToTop_PageNavigation(
                  context,
                  Forumdetailscreen(
                    forumPost: data,
                    // postData: data,
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(2.0),
                    height: 100.sp,
                    width: 100.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.sp),
                      child: ImageWidget(imageUrl: data.imagePath),
                    ),
                  ),
                  SizedBox(width: 5.sp),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 190.sp,
                        child: Text(
                          data.caption,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Wrap(
                        children: data.tags.map((tag) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.sp),
                            child: bubble(
                              heading: tag.name,
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10.sp,
                                  child: ClipOval(
                                    child: ImageWidget(
                                      imageUrl: data.user.profile ?? "",
                                      width: 100.sp,
                                      height: 100.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.sp),
                                Text(
                                  data.user.name.isNotEmpty
                                      ? data.user.name
                                      : "Unknown User",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(width: 70.sp),
                            // SvgPicture.asset(
                            //   "assets/icons/newIcons/heart.svg",
                            //   height: 15.sp,
                            //   width: 15.sp,
                            //   color: Colors.black.withOpacity(0.3),
                            // ),
                            // SizedBox(width: 5.sp),
                            // SvgPicture.asset(
                            //   "assets/icons/comment.svg",
                            //   height: 15.sp,
                            //   width: 15.sp,
                            //   color: Colors.black.withOpacity(0.3),
                            // ),
                            // SizedBox(width: 5.sp),
                            // SvgPicture.asset(
                            //   "assets/icons/send.svg",
                            //   height: 15.sp,
                            //   width: 15.sp,
                            //   color: Colors.black.withOpacity(0.3),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if(DataStroge.currentUser.value!.id == data.userId)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Edit') {
                    Navigation.getInstance
                        .RightToLeft_PageNavigation(context, AddforumScreen(forumPost: data));
                  } else if (value == 'Delete') {
                    forumController.deletePost(data.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'Edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue, size: 18.sp),
                        SizedBox(width: 8.sp),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 18.sp),
                        SizedBox(width: 8.sp),
                        Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                icon: Icon(Icons.more_vert, size: 18.sp, color: Colors.grey.shade600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                color: Colors.white,
                elevation: 2,
              ),
          ],
        ),
      );
    });
  }
}


