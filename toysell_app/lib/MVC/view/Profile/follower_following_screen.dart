import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/model/userModel.dart';
import '../../../constant/navigation.dart';
import '../../../constant/theme.dart';
import '../../../helper/data_storage.dart';
import '../../controller/FollowFollowingController.dart';
import 'ProfileScreen.dart';

class FollowersFollowingScreen extends StatelessWidget {
  final String title; // Either "Followers" or "Following"
  final List<UserModel> users; // List of UserModel

  FollowersFollowingScreen({
    super.key,
    required this.title,
    required this.users,
  });

  final followFollowingController = Get.put(FollowFollowingController());
  final currentUserFollowFollowingController = Get.put(FollowFollowingController());

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeHelper>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          RxBool isFollowing = (title == "following".tr).obs; // Initially assume based on the title

          return Obx(() =>
              ListTile(
                leading: CircleAvatar(
                  radius: 25.sp,
                  backgroundImage: NetworkImage(
                    user.profile ??
                        "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg",
                  ),
                ),
                title: Text(
                  user.name.isNotEmpty ? user.name : "Unknown User",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: themeController.textcolor,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Row(
                      children: List.generate(
                        5,
                            (starIndex) =>
                            SvgPicture.asset(
                              "assets/icons/star.svg",
                              height: 16.sp,
                              width: 16.sp,
                              color: Colors.yellow,
                            ),
                      ),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final token = DataStroge.accesstoken.value;

                    if (isFollowing.value) {
                      await followFollowingController.unfollowUser(
                          userId: user.id, token: token);
                      isFollowing.value = false;
                      // Get.snackbar("Unfollowed", "You unfollowed ${user.name}");
                    } else {
                      await followFollowingController.followUser(
                          userId: user.id, token: token);
                      isFollowing.value = true;
                      // Get.snackbar("Followed", "You followed ${user.name}");
                    }
                    Future.wait([
                      currentUserFollowFollowingController.getFollowers(DataStroge.currentUser.value!.id, DataStroge.accesstoken.value),
                      currentUserFollowFollowingController.getFollowing(DataStroge.currentUser.value!.id, DataStroge.accesstoken.value),
                    ]);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isFollowing.value ? Colors.red : themeController.colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                  child: Text(
                    currentUserFollowFollowingController.following.any((f) =>
                    f.id != DataStroge.currentUser.value!.id,)
                        ? "unfollow".tr
                        : currentUserFollowFollowingController.followers.any((f) =>
                    f.id != DataStroge.currentUser.value!.id,) ? "follow".tr : user.id !=
                        DataStroge.currentUser.value!.id ? "follow".tr : '',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                ),
                onTap: () {
                  // Navigate to the user's profile
                  Navigation.getInstance.bottomToTop_PageNavigation(
                    context,
                    ProfileScreen(
                      isSelf: false,
                      userId: user.id,
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}
