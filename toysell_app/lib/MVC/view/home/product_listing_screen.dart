import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../components/product_card.dart';
import '../../../constant/asset_paths.dart';
import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../MVC/controller/productController.dart';
import '../commonScreens/shimmer_product_card.dart';

class ProductListingScreen extends StatefulWidget {
  final int categoryId; // Selected category ID
  final String title; // Category name for the screen title

  ProductListingScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  ProductController productController = Get.put(ProductController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    productController.fetchProducts(categoryId: widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return AnnotatedRegion(
        value: themeController.systemUiOverlayStyleForwhite,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              widget.title,
              style: TextStyle(
                color: themeController.textcolor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: themeController.colorIcon),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constants.screenPadding),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    child: Container(
                      height: 34.sp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.sp),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                productController.searchQuery.value = value.trim();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 8.sp, left: 10.0),
                                hintText: 'search_hint'.trParams({'category': widget.title}),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Obx(() {
                    final filteredProducts = productController.filteredProducts;

                    if (productController.isLoading.value) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.sp,
                          mainAxisSpacing: 12.sp,
                          childAspectRatio: 0.5,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return const ShimmerProductCard();
                        },
                      );
                    }

                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          'no_products_found'.tr,
                          style: TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.sp,
                        mainAxisSpacing: 12.sp,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        var product = filteredProducts[index];
                        return ProductCard(
                          data: product,
                          isFavourite: productController.isInFavourite(product.id),
                          onLikePressed: () {
                            productController.addOrRemoveFavouriteProduct(product.id);
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
      );
    });
  }
}
