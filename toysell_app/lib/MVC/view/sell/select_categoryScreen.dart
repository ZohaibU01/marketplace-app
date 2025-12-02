import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/productController.dart';
import 'package:toysell_app/MVC/model/categoryModel.dart';
import 'package:toysell_app/MVC/view/sell/sellsFormScreen.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import '../../../components/category_card.dart';
import '../../../components/image_widget.dart';
import '../../controller/category_controller.dart';

class SelectCategoryScreen extends StatelessWidget {
  SelectCategoryScreen({super.key});

  final CategoryController categoryController = Get.put(CategoryController()..fetchAllCategories());

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
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Constants.screenPadding,
              vertical: Constants.screenPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Text(
                        'select_category'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 20.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Obx(
                        () {
                          if (categoryController.isLoading.value) {
                            return _buildShimmerGrid();
                          }

                      final categories = categoryController.categories.value;

                      if (categories.isEmpty) {
                        return Center(
                          child: Text(
                            'no_categories_found'.tr,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 10.h,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return SpringWidget(
                            onTap: () {
                              Navigation.getInstance.bottomToTop_PageNavigation(
                                context,
                                SellFormscreen(categoryModel: category),
                              ).then((value){
                                Get.find<ProductController>().onInit();
                              },);
                            },
                            child: CategoryCard(data: category),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.9,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Column(
              children: [
                // Simulate Image Area
                Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.sp),
                    ),
                  ),
                ),
                // SizedBox(height: 10.h),
                // // Simulate Text Area
                // Container(
                //   height: 14.sp,
                //   width: 60.w,
                //   color: Colors.grey.shade300,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
