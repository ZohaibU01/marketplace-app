import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/SellsController.dart';
import 'package:toysell_app/MVC/view/commonScreens/productDetailScreen.dart';
import 'package:toysell_app/MVC/view/commonScreens/shimmer_product_card.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/image_picker_bottom_sheet.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/product_card.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/data/mockData.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:toysell_app/helper/internet_controller.dart';

import '../../controller/productController.dart';

class Likepostscreen extends StatelessWidget {
  Likepostscreen({super.key});

  // final internetController = Get.put(InternetController());
  final productController = Get.put(ProductController());

  final themeController = Get.find<ThemeHelper>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
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
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    automaticallyImplyLeading: false,
                    title: Text(
                      'Wishlist',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.sp),
                    )),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.screenPadding,
                      vertical: Constants.screenPadding),
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(
                              () {
                            if (productController.isLoading.value) {
                              // Show shimmer loading state
                              return _buildShimmerGrid();
                            }

                            if (productController.favoriteProducts.isEmpty) {
                              return Center(
                                child: Text(
                                  'No favorite products found',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }

                            // Show actual product grid
                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.sp,
                                mainAxisSpacing: 12.sp,
                                childAspectRatio: 0.5,
                              ),
                              itemCount: productController.favoriteProducts.length,
                              itemBuilder: (context, index) {
                                var product = productController.favoriteProducts[index];
                                return ProductCard(
                                  data: productController.products.firstWhere((p) => p.id == product.id,),
                                  isFavourite: productController.isInFavourite(product.id),
                                  onLikePressed: () {
                                    productController.addOrRemoveFavouriteProduct(product.id);
                                  },
                                  onEditPressed: (){},
                                  onDeletePressed: (){},
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
            ));
      }
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
      itemCount: 6, // Number of shimmer cards to display
      itemBuilder: (context, index) {
        return const ShimmerProductCard();
      },
    );
  }
}
