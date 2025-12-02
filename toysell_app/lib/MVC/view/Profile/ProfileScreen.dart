import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/category_controller.dart';
import 'package:toysell_app/MVC/controller/productController.dart';
import 'package:toysell_app/MVC/controller/user_product_controller.dart';
import 'package:toysell_app/MVC/controller/FollowFollowingController.dart';
import 'package:toysell_app/MVC/controller/user_controller.dart';
import 'package:toysell_app/MVC/view/Profile/editProfileScreen.dart';
import 'package:toysell_app/MVC/view/Profile/profileSettingScreen.dart';
import 'package:toysell_app/MVC/view/Profile/ratingScreen.dart';
import 'package:toysell_app/MVC/view/sell/sellsFormScreen.dart';
import 'package:toysell_app/components/product_card.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/data_storage.dart';
import '../../../components/rating.dart';
import '../../../components/spring_widget.dart';
import '../commonScreens/shimmer_product_card.dart';
import 'follower_following_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isSelf;
  final int userId;

  ProfileScreen({super.key, required this.isSelf, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RxBool isFollowing = false.obs;

  bool isLoadingScreen = true;

  final RxString selectedTab = 'Active'.obs;

  final userProductController = Get.put(UserProductController());
  final productController = Get.put(ProductController());

  final currentUserFollowFollowingController = Get.put(FollowFollowingController());
  final followFollowingController = Get.put(FollowFollowingController());

  final userController = Get.put(UserController());

  final categoryController = Get.put(CategoryController());

  final themeController = Get.find<ThemeHelper>();

  @override
  void initState() {
    Future.wait([
      userController.getUserDetails(widget.userId, DataStroge.accesstoken.value),
      followFollowingController.getFollowers(widget.userId, DataStroge.accesstoken.value).then((_) {
        if (!widget.isSelf) {
          isFollowing.value = followFollowingController.followers.any(
            (f) => f.id == DataStroge.currentUser.value!.id,
          );
        }
      }),
      followFollowingController.getFollowing(widget.userId, DataStroge.accesstoken.value),
      //     .then((_) {
      //   if (widget.isSelf) {
      //     isFollowing.value = followFollowingController.following.any(
      //       (f) => f.id == DataStroge.currentUser.value!.id,
      //     );
      //   }
      // }),
      userProductController.fetchProducts(userId: widget.userId),
      currentUserFollowFollowingController.getFollowers(
          DataStroge.currentUser.value!.id, DataStroge.accesstoken.value),
      currentUserFollowFollowingController.getFollowing(
          DataStroge.currentUser.value!.id, DataStroge.accesstoken.value),
    ]).then(
      (value) => mounted
          ? setState(() {
              isLoadingScreen = false;
            })
          : null,
    );

    super.initState();
  }

  Future<void> _toggleFollow() async {
    try {
      if (isFollowing.value) {
        // Unfollow user
        await followFollowingController.unfollowUser(
          userId: widget.userId,
          token: DataStroge.accesstoken.value,
        );
        isFollowing.value = false;
      } else {
        // Follow user
        await followFollowingController.followUser(
          userId: widget.userId,
          token: DataStroge.accesstoken.value,
        );
        isFollowing.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update follow status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Obx(() {
        final user = userController.user.value;

        return AnnotatedRegion(
          value: themecontroller.systemUiOverlayStyleforwhiteandtarnsparent,
          child: Scaffold(
            backgroundColor: themecontroller.backgoundcolor,
            appBar: AppBar(
              shadowColor: Colors.black,
              backgroundColor: themecontroller.backgoundcolor,
              surfaceTintColor: themecontroller.backgoundcolor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                'profile'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: widget.isSelf
                  ? null
                  : IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              actions: isLoadingScreen
                  ? []
                  : [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!widget.isSelf)
                              Obx(() {
                                return ElevatedButton(
                                  onPressed: _toggleFollow,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFollowing.value
                                        ? Colors.grey.shade300
                                        : themecontroller.colorPrimary,
                                    foregroundColor:
                                        isFollowing.value ? Colors.black : Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                  ),
                                  child: Text(
                                    isFollowing.value ? 'following'.tr : 'follow'.tr,
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                                );
                              })
                            else
                              SpringWidget(
                                onTap: () {
                                  Navigation.getInstance
                                      .RightToLeft_PageNavigation(context, ProfileSettingScreen(user: user));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                                  child: SvgPicture.asset(
                                    "assets/icons/threeDot.svg",
                                    height: 20.sp,
                                    width: 20.sp,
                                    color: themecontroller.greyColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
            ),
            body: isLoadingScreen
                ? _buildProfileShimmer(themecontroller)
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.sp),
                        // Profile Image with Edit Button
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60.sp,
                              backgroundImage: NetworkImage(
                                user.profile ??
                                    "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg",
                              ),
                            ),
                            if (widget.isSelf)
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigation.getInstance.RightToLeft_PageNavigation(
                                      context,
                                      EditProfileScreen(),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(4.sp),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeController.colorPrimary,
                                    ),
                                    child: Icon(Icons.edit, color: Colors.white, size: 16.sp),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.sp),
                        Text(
                          user.name.isNotEmpty ? user.name.toUpperCase() : "unknown_user".tr,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     SvgPicture.asset(
                        //       "assets/icons/star.svg",
                        //       height: 20.sp,
                        //       width: 20.sp,
                        //       color: Colors.yellow,
                        //     ),
                        //     SvgPicture.asset(
                        //       "assets/icons/star.svg",
                        //       height: 20.sp,
                        //       width: 20.sp,
                        //       color: Colors.yellow,
                        //     ),
                        //     SvgPicture.asset(
                        //       "assets/icons/star.svg",
                        //       height: 20.sp,
                        //       width: 20.sp,
                        //       color: Colors.yellow,
                        //     ),
                        //     SvgPicture.asset(
                        //       "assets/icons/star.svg",
                        //       height: 20.sp,
                        //       width: 20.sp,
                        //       color: Colors.yellow,
                        //     ),
                        //     SvgPicture.asset(
                        //       "assets/icons/star.svg",
                        //       height: 20.sp,
                        //       width: 20.sp,
                        //       color: Colors.yellow,
                        //     ),
                        //     Text(
                        //       "(5.0)",
                        //       style: TextStyle(fontSize: 12.sp, color: Colors.black),
                        //     )
                        //   ],
                        // ),

                        StarRating(
                          rating: user.averageRating ?? 0,
                          onTap: () {
                            Navigation.getInstance.RightToLeft_PageNavigation(
                                context, RatingScreen(ratings: user.ratings));
                          },
                        ),
                        SizedBox(height: 10.sp),
                        Divider(color: Colors.black.withOpacity(0.1), thickness: 2.sp),
                        // Followers and Following
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/sells.svg",
                                height: 17.sp,
                                width: 17.sp,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Text(
                                userController.getTotalSales(user.id).toString(),
                                style:
                                    TextStyle(fontSize: 12.sp, color: themecontroller.colorPrimary),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Text(
                                "sales".tr.toLowerCase(),
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black.withOpacity(0.9)),
                              ),
                              SizedBox(
                                width: 10.sp,
                              ),
                              Text(
                                userController.getTotalPurchases(user.id).toString(),
                                style:
                                    TextStyle(fontSize: 12.sp, color: themecontroller.colorPrimary),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Text(
                                "purchases".tr.toLowerCase(),
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black.withOpacity(0.9)),
                              ),
                              Spacer(),
                              Obx(() {
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigation.getInstance.RightToLeft_PageNavigation(
                                          context,
                                          FollowersFollowingScreen(
                                            title: "followers".tr,
                                            users: followFollowingController.followers,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/follow.svg",
                                            height: 17.sp,
                                            width: 17.sp,
                                            color: Colors.black.withOpacity(0.3),
                                          ),
                                          SizedBox(
                                            width: 5.sp,
                                          ),
                                          Text(
                                            followFollowingController.followers.length.toString(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: themecontroller.colorPrimary,
                                              decoration: TextDecoration.underline,
                                              decorationColor: themecontroller.greyColor,
                                            ),
                                          ),
                                          SizedBox(width: 5.sp),
                                          Text(
                                            "followers".tr.toLowerCase(),
                                            style: TextStyle(
                                                fontSize: 12.sp, color: themecontroller.greyColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.sp),
                                    GestureDetector(
                                      onTap: () {
                                        Navigation.getInstance.RightToLeft_PageNavigation(
                                          context,
                                          FollowersFollowingScreen(
                                            title: "following".tr,
                                            users: followFollowingController.following,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            followFollowingController.following.length.toString(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: themecontroller.colorPrimary,
                                              decoration: TextDecoration.underline,
                                              decorationColor: themecontroller.greyColor,
                                            ),
                                          ),
                                          SizedBox(width: 5.sp),
                                          Text(
                                            "following".tr.toLowerCase(),
                                            style: TextStyle(
                                                fontSize: 12.sp, color: themecontroller.greyColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Obx(() {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildTabButton(
                                  label: 'active'.tr,
                                  isSelected: selectedTab.value == 'Active',
                                  onTap: () {
                                    selectedTab.value = 'Active';
                                  },
                                  themecontroller: themecontroller,
                                ),
                                if (widget.isSelf) ...[
                                  SizedBox(width: 10.sp),
                                  _buildTabButton(
                                    label: " ${'sold'.tr} ",
                                    isSelected: selectedTab.value == 'Sold',
                                    onTap: () {
                                      selectedTab.value = 'Sold';
                                    },
                                    themecontroller: themecontroller,
                                  ),
                                ]
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          height: 20.sp,
                        ),
                        // Product Grid
                        Obx(() {
                          if (userProductController.isLoading.value) {
                            return GridView.builder(
                              padding: EdgeInsets.only(bottom: 10.sp),
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.sp,
                                mainAxisSpacing: 12.sp,
                                childAspectRatio: 0.5,
                              ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return ShimmerProductCard();
                              },
                            );
                          }

                          if (userProductController.Myproducts.isEmpty) {
                            return Center(
                              child: Text(
                                'no_products_found'.tr,
                                style: TextStyle(color: Colors.black, fontSize: 14.sp),
                              ),
                            );
                          }

                          var products = userProductController.Myproducts.where((p) {
                            if (selectedTab.value == "Active") {
                              return p.status != "sold out";
                            } else {
                              return p.status == "sold out";
                            }
                          }).toList();

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Constants.screenPadding,
                                vertical: Constants.screenPadding),
                            child: GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.sp,
                                mainAxisSpacing: 12.sp,
                                childAspectRatio: 0.5,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  data: product,
                                  isSelf: widget.isSelf,
                                  isFavourite: productController.isInFavourite(product.id),
                                  onEditPressed: () {
                                    if (widget.isSelf) {
                                      Navigation.getInstance.bottomToTop_PageNavigation(
                                        context,
                                        SellFormscreen(
                                          categoryModel: categoryController.categories.firstWhere(
                                            (cat) =>
                                                cat.subcategories?.any(
                                                  (subCat) => subCat.id == product.categoryId,
                                                ) ??
                                                false,
                                          ),
                                          productData: product,
                                        ),
                                      ).then((_){userProductController.fetchProducts(userId: user.id);});
                                    }
                                  },
                                  onDeletePressed: () async {
                                    await userProductController.deleteProduct(product);
                                  },
                                  onLikePressed: () {
                                    if (!widget.isSelf) {
                                      productController
                                          .addOrRemoveFavouriteProduct(product.id);
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
          ),
        );
      });
    });
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeHelper themecontroller,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
        decoration: BoxDecoration(
          color: isSelected ? themecontroller.colorPrimary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: themecontroller.colorwhite,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Shimmer for Profile
  Widget _buildProfileShimmer(ThemeHelper themecontroller) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            SizedBox(height: 20.sp),
            CircleAvatar(
              radius: 60.sp,
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(height: 10.sp),
            Container(
              height: 20.sp,
              width: 150.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 10.sp),
            Container(
              height: 15.sp,
              width: 100.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 10.sp),
            Divider(color: Colors.grey.shade300, thickness: 2.sp),
            SizedBox(height: 20.sp),
            _buildProductGridShimmer(),
          ],
        ),
      ),
    );
  }

// Shimmer for Product Grid
  Widget _buildProductGridShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.sp,
          mainAxisSpacing: 12.sp,
          childAspectRatio: 0.5,
        ),
        itemCount: 6,
        // Placeholder item count for shimmer
        itemBuilder: (context, index) {
          return ShimmerProductCard();
        },
      ),
    );
  }
}
