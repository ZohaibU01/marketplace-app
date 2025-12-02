import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:toysell_app/MVC/model/forum_model.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/theme.dart';

import '../../../components/gradient_button.dart';
import '../../../helper/data_storage.dart';
import '../../controller/forumController.dart';

class Forumdetailscreen extends StatelessWidget {
  final ForumPost forumPost;

  Forumdetailscreen({super.key, required this.forumPost});

  final ForumController forumController = Get.put(ForumController());
  final ThemeHelper themeController = Get.put(ThemeHelper());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: themeController.systemUiOverlayStyleForwhite,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: themeController.backgoundcolor,
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
              'view_post'.tr,
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
            child: Obx(() {
              if (forumController.isLoading.value) {
                return _buildShimmerLoading();
              }

              var post = forumController.forumPosts.firstWhere((p) => p.id == forumPost.id);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPostHeader(themeController, post),
                    SizedBox(height: 20.sp),
                    _buildCommentsSection(post),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader(ThemeHelper themeController, ForumPost post) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.sp,
                      child: ClipOval(
                        child: ImageWidget(
                          imageUrl: post.user.profile ??
                              "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg",
                          width: 40.sp,
                          height: 40.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user.name.isNotEmpty ? post.user.name : "Anonymous".tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _formatTime(post.createdAt),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.sp),
                Text(
                  post.caption,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 10.sp),
                Wrap(
                  children: post.tags
                      .map((tag) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            child: _buildTagChip(tag.name),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.sp),
          _buildPostImage(themeController, post),
          SizedBox(height: 10.sp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
            child: _buildPostActions(themeController, post),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildPostImage(ThemeHelper themeController, ForumPost post) {
    return Container(
      height: 200.sp,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: themeController.colorPrimary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.sp),
        child: ImageWidget(imageUrl: post.imagePath),
      ),
    );
  }

  Widget _buildPostActions(ThemeHelper themeController, ForumPost post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SpringWidget(
              onTap: () {
                forumController.likePost(post.id);
              },
              child: Row(
                children: [
                  Icon(
                      post.likes.any(
                        (l) => l.userId == DataStroge.currentUser.value!.id,
                      )
                          ? Icons.favorite_rounded
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 18.sp),
                  SizedBox(width: 5.sp),
                  Text(
                    '${post.likes.length}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.sp),
            SpringWidget(
              onTap: () {
                _showAddCommentDialog(post);
              },
              child: Row(
                children: [
                  Icon(Icons.comment_outlined, color: Colors.black45, size: 18.sp),
                  SizedBox(width: 5.sp),
                  Text(
                    '${post.comments.length}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentsSection(ForumPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${'replies_count'.tr}(${post.comments.length})",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.sp),
        ListView.builder(
          itemCount: post.comments.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final comment = post.comments[index];
            return _buildCommentCard(comment);
          },
        ),
      ],
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.sp),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User and Time Info with Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        child: ClipOval(
                          child: ImageWidget(
                            imageUrl: comment.user.profile ??
                                "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg",
                            width: 40.sp,
                            height: 40.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.sp),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.user.name.isNotEmpty ? comment.user.name : "Anonymous",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _formatTime(comment.createdAt),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (DataStroge.currentUser.value!.id == comment.user.id)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          _showEditCommentDialog(comment);
                        } else if (value == 'Delete') {
                          forumController.deleteComment(comment.id);
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
              SizedBox(height: 10.sp),

              // Comment Content
              Text(
                comment.content,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 10.sp),

              // Like and Reply Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SpringWidget(
                    onTap: () {
                      forumController.likeComment(comment.id);
                    },
                    child: Row(
                      children: [
                        Icon(
                          comment.likes.any(
                                (l) => l.userId == DataStroge.currentUser.value!.id,
                          )
                              ? Icons.favorite_rounded
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 16.sp,
                        ),
                        SizedBox(width: 5.sp),
                        Text(
                          "${comment.likes.length}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.sp),
                  SpringWidget(
                    onTap: () {
                      _showReplyDialog(comment);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.reply,
                          color: Colors.black45,
                          size: 16.sp,
                        ),
                        SizedBox(width: 5.sp),
                        Text(
                          "Reply",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Replies Section
              if (comment.replies.isNotEmpty) ...[
                Divider(color: Colors.grey.shade300, thickness: 1.sp),
                Padding(
                  padding: EdgeInsets.only(left: 10.sp, top: 5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: comment.replies.map((reply) => _buildReplyCard(reply)).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

// Helper Method to Display a Reply Card
  Widget _buildReplyCard(Comment reply) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15.sp,
            child: ClipOval(
              child: ImageWidget(
                imageUrl: reply.user.profile ??
                    "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg",
                width: 30.sp,
                height: 30.sp,
              ),
            ),
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.user.name.isNotEmpty ? reply.user.name : "Anonymous",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _formatTime(reply.createdAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 5.sp),
                Text(
                  reply.content,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (DataStroge.currentUser.value!.id == reply.user.id)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Edit') {
                  _showEditReplyDialog(reply);
                } else if (value == 'Delete') {
                  forumController.deleteComment(reply.id);
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
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header Skeleton
            Container(
              height: 100.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.sp),
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.sp),
            // Image Skeleton
            Container(
              height: 200.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.sp),
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.sp),
            // Comments Section Skeleton
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                5,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: 10.sp),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 10.sp),
                      Expanded(
                        child: Container(
                          height: 50.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Add Comment Dialog
  void _showAddCommentDialog(ForumPost post) {
    final TextEditingController commentController = TextEditingController();
    final themeController = Get.find<ThemeHelper>();

    _showPopup(
      context: Get.context!,
      title: "Add Comment",
      content: TextField(
        controller: commentController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Write your comment...',
          hintStyle: TextStyle(
            color: themeController.textcolor,
            fontSize: 14.sp,
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
      buttonText: "Post",
      onButtonPressed: () {
        final commentText = commentController.text.trim();
        if (commentText.isNotEmpty) {
          forumController.commentOnPost(post.id, commentText);
          Get.back(); // Close the dialog
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("Please enter a comment.")),
          );
        }
      },
    );
  }

// Show Reply to Comment Dialog
  void _showReplyDialog(Comment comment) {
    final TextEditingController replyController = TextEditingController();
    final themeController = Get.find<ThemeHelper>();

    _showPopup(
      context: Get.context!,
      title: "Reply to Comment",
      content: TextField(
        controller: replyController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Write your reply...',
          hintStyle: TextStyle(
            color: themeController.textcolor,
            fontSize: 14.sp,
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
      buttonText: "Reply",
      onButtonPressed: () {
        final replyText = replyController.text.trim();
        if (replyText.isNotEmpty) {
          forumController.replyToComment(comment.id, replyText);
          Get.back(); // Close the dialog
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("Please enter a reply.")),
          );
        }
      },
    );
  }

  void _showEditCommentDialog(Comment comment) {
    final TextEditingController editController = TextEditingController(text: comment.content);
    final themeController = Get.find<ThemeHelper>();

    _showPopup(
      context: Get.context!,
      title: "Edit Comment",
      content: TextField(
        controller: editController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Edit your comment...',
          hintStyle: TextStyle(
            color: themeController.textcolor,
            fontSize: 14.sp,
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
      buttonText: "Save",
      onButtonPressed: () {
        final editedText = editController.text.trim();
        if (editedText.isNotEmpty) {
          forumController.editComment(comment.id, editedText); // Call the edit comment API
          Get.back(); // Close the dialog
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("Please enter a valid comment.")),
          );
        }
      },
    );
  }

  void _showEditReplyDialog(Comment reply) {
    final TextEditingController editController = TextEditingController(text: reply.content);
    final themeController = Get.find<ThemeHelper>();

    _showPopup(
      context: Get.context!,
      title: "Edit Reply",
      content: TextField(
        controller: editController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Edit your reply...',
          hintStyle: TextStyle(
            color: themeController.textcolor,
            fontSize: 14.sp,
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
      buttonText: "Save",
      onButtonPressed: () {
        final editedText = editController.text.trim();
        if (editedText.isNotEmpty) {
          forumController.editComment(reply.id, editedText); // Call the edit reply API
          Get.back(); // Close the dialog
        } else {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("Please enter a valid reply.")),
          );
        }
      },
    );
  }

// Helper Method for Popup Dialog
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
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Icon
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

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: themeController.textcolor,
                  ),
                ),
                SizedBox(height: 10.sp),

                // Divider
                Divider(thickness: 1, color: themeController.colorIcon),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.sp),
                  child: content,
                ),

                // Gradient Button
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

  String _formatTime(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 3) {
      return DateFormat('EEE \'at\' h:mm a').format(dateTime);
    } else {
      return timeago.format(dateTime);
    }
  }
}
