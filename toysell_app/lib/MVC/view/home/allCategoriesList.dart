import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/category_controller.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'subcategoryScreen.dart';

class AllCategoriesList extends StatelessWidget {
  AllCategoriesList({super.key});

  final categoryController = Get.put(CategoryController()..fetchAllCategories());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return AnnotatedRegion(
        value: themeController.systemUiOverlayStyleForwhite,
        child: Scaffold(
          backgroundColor: themeController.backgoundcolor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            surfaceTintColor: themeController.backgoundcolor,
            backgroundColor: themeController.backgoundcolor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'details'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.sp,
              ),
            ),
          ),
          body: Obx(
                () {
              if (categoryController.isLoading.value) {
                return ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildShimmerItem(themeController);
                  },
                );
              }

              if (categoryController.categories.isEmpty) {
                return Center(
                  child: Text(
                    'no_categories_found'.tr,
                    style: TextStyle(color: Colors.black, fontSize: 14.sp),
                  ),
                );
              }

              return ListView.builder(
                itemCount: categoryController.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = categoryController.categories[index];
                  return SpringWidget(
                    onTap: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                        context,
                        SubProductCategoryScreen(
                          title: category.name,
                          subCategories: category.subcategories ?? [],
                          parentCategoryId: category.id,
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeController.backgoundcolor,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withOpacity(0.2),
                            width: 1.sp,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ImageWidget(
                                  height: 30.sp,
                                  width: 30.sp,
                                  imageUrl: category.icon ?? "",
                                ),
                                SizedBox(width: 15.sp),
                                Text(
                                  category.name,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildShimmerItem(ThemeHelper themeController) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 5.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Avatar Placeholder
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(width: 10.sp),
            // Title and Subtitle Placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Placeholder
                  Container(
                    width: 150.sp,
                    height: 14.sp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.sp),
                    ),
                  ),
                  SizedBox(height: 6.sp),
                  // Subtitle Placeholder
                  Container(
                    width: 100.sp,
                    height: 12.sp,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4.sp),
                    ),
                  ),
                ],
              ),
            ),
            // Trailing Placeholder
            Container(
              width: 20.sp,
              height: 20.sp,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
