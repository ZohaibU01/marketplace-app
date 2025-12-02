import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/order_controller.dart';
import 'package:toysell_app/MVC/view/commonScreens/NotificationScreen.dart';
import 'package:toysell_app/MVC/view/forums/forumsList.dart';
import 'package:toysell_app/MVC/view/home/likePostScreen.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../../../components/dropdown.dart';
import '../../../components/product_card.dart';
import '../../controller/productController.dart';
import '../../controller/user_controller.dart';
import '../Profile/ProfileScreen.dart';
import '../commonScreens/shimmer_product_card.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final productController = Get.put(ProductController());
  final userController = Get.put(UserController());
  // final _ = Get.put(OrderController());
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'products'.tr;

  @override
  void initState() {
    super.initState();
    userController.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwhite,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
              child: RefreshIndicator(
                onRefresh: () async => await Future.wait([
                  productController.fetchProducts(),
                  userController.fetchAllUsers(),
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SpringWidget(
                            onTap: () {
                              Navigation.getInstance
                                  .RightToLeft_PageNavigation(context, Forumslist());
                            },
                            child: SvgPicture.asset(
                              AssetPaths.forumIconSVG,
                              height: 22.sp,
                              width: 22.sp,
                              color: themecontroller.colorIcon,
                            ),
                          ),
                          Row(
                            children: [
                              SpringWidget(
                                onTap: () {
                                  Navigation.getInstance
                                      .RightToLeft_PageNavigation(context, Likepostscreen());
                                },
                                child: SvgPicture.asset(
                                  AssetPaths.heartIconSVG,
                                  height: 20.sp,
                                  width: 20.sp,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8.sp),
                              SpringWidget(
                                onTap: () {
                                  Navigation.getInstance
                                      .RightToLeft_PageNavigation(context, Notificationscreen());
                                },
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      AssetPaths.bellIconSVG,
                                      height: 20.sp,
                                      width: 20.sp,
                                      color: Colors.black,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: CircleAvatar(
                                        radius: 5.sp,
                                        backgroundColor: Colors.red,
                                        child: Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(color: Colors.white, fontSize: 5.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Container(
                        height: 34.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.sp),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 0.27.sw,
                              child: CustomDropdown(
                                items: [
                                  'products'.tr,
                                  'members'.tr,
                                ],
                                initialValue: 'products'.tr,
                                onValueChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10.sp),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  productController.searchQuery.value = value.trim();
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 8.sp),
                                  hintText: "search_hint".tr,
                                  hintStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                AssetPaths.searchBarIconSVG,
                                height: 20.sp,
                                width: 20.sp,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: selectedCategory == 'members'.tr
                          ? Obx(() {
                              if (userController.isLoading.value) {
                                return _buildShimmerList();
                              }
                              if (userController.users.isEmpty) {
                                return Center(
                                  child: Text(
                                    'no_members_found'.tr,
                                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                                  ),
                                );
                              }
                              final filteredUsers = userController.users.where((user) {
                                return user.name
                                        .toLowerCase()
                                        .contains(searchController.text.toLowerCase()) &&
                                    user.id != DataStroge.currentUser.value?.id;
                              }).toList();

                              return ListView.builder(
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(user.profile ??
                                              "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg")
                                          as ImageProvider,
                                    ),
                                    title: Text(
                                      user.name.isNotEmpty ? user.name : "unknown_user".tr,
                                      style:
                                          TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      user.email,
                                      style:
                                          TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                                    ),
                                    onTap: () {
                                      Navigation.getInstance.bottomToTop_PageNavigation(
                                        context,
                                        ProfileScreen(
                                          isSelf: user.id == DataStroge.currentUser.value!.id,
                                          userId: user.id,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            })
                          : Obx(() {
                              return productController.isLoading.value
                                  ? _buildShimmerGrid()
                                  : productController.filteredProducts.isEmpty
                                      ? Center(
                                          child: Text(
                                            'no_products_found'.tr,
                                            style: TextStyle(color: Colors.black, fontSize: 14.sp),
                                          ),
                                        )
                                      : GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12.sp,
                                            mainAxisSpacing: 12.sp,
                                            childAspectRatio: 0.5,
                                          ),
                                          itemCount: productController.filteredProducts.length,
                                          itemBuilder: (context, index) {
                                            var product = productController.filteredProducts[index];
                                            return ProductCard(
                                              data: product,
                                              isFavourite:
                                                  productController.isInFavourite(product.id),
                                              onLikePressed: () {
                                                productController
                                                    .addOrRemoveFavouriteProduct(product.id);
                                              },
                                              onEditPressed: () {},
                                              onDeletePressed: () {},
                                            );
                                          },
                                        );
                            }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
              ),
              title: Container(
                height: 12.sp,
                width: 100.sp,
                color: Colors.grey[300],
              ),
              subtitle: Container(
                height: 10.sp,
                width: 150.sp,
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
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
}
