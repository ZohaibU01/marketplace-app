import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/MVC/view/Profile/ProfileScreen.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import '../MVC/view/commonScreens/productDetailScreen.dart';
import '../constant/asset_paths.dart';
import 'image_widget.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.data,
    this.isFavourite,
    required this.onLikePressed,
    this.isSelf = false,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final ProductModel data;
  final bool? isFavourite;
  final VoidCallback onLikePressed;
  final bool isSelf; // Indicates if the user is the product owner
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// User Info and Dropdown Menu
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.sp,horizontal: 2.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SpringWidget(
                      onTap: () {
                        Navigation.getInstance.bottomToTop_PageNavigation(
                          context,
                          ProfileScreen(isSelf: false,userId: data.userId,),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12.sp,
                            child: ClipOval(
                              child: ImageWidget(
                                imageUrl: data.sellerPicture ?? "",
                                width: 100.sp,
                                height: 100.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 5.sp),
                          Text(
                            data.sellerName.capitalize ?? data.sellerName,
                            style: TextStyle(
                              color: controller.colorIcon,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelf)
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: controller.colorIcon),
                        color: controller.colorwhite,
                        onSelected: (value) {
                          if (value == 'edit') {
                            onEditPressed();
                          } else if (value == 'delete') {
                            onDeletePressed();
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: controller.colorPrimary),
                                  SizedBox(width: 8.sp),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8.sp),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                  ],
                ),
              ),
              /// Product Image
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    /// Product Image
                    SpringWidget(
                      onTap: () {
                        Navigation.getInstance.bottomToTop_PageNavigation(
                          context,
                          ProductDetailScreen(data: data),
                        );
                      },
                      child: ClipRRect(
                        child: ImageWidget(
                          imageUrl: data.imageUrl,
                          boxfit: BoxFit.fitHeight,
                          width: double.maxFinite,
                          height: 600.sp,
                        ),
                      ),
                    ),

                    /// 🔥 Featured Banner
                    if (data.isFeature)
                      Positioned(
                        top: 8.sp,
                        left: 8.sp,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                          decoration: BoxDecoration(
                            color: controller.colorPrimary,
                            borderRadius: BorderRadius.circular(4.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            "FEATURED",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                    /// Like Button
                    Positioned(
                      bottom: 4.sp,
                      right: 4.sp,
                      child: SpringWidget(
                        onTap: onLikePressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                (isFavourite != null && isFavourite!)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: (isFavourite != null && isFavourite!)
                                    ? Colors.red
                                    : Colors.black45,
                                size: 18.sp,
                              ),
                              SizedBox(width: 4.sp),
                              Text(
                                data.likeCount.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
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
              /// Product Details
              Expanded(
                flex: 2,
                child: SpringWidget(
                  onTap: () {
                    Navigation.getInstance.bottomToTop_PageNavigation(
                      context,
                      ProductDetailScreen(data: data),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.sp),
                        Text(
                          data.name.isEmpty ? "Mint Mojito–Color BAR" : data.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.sp),
                        Text(
                          "\$${data.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: controller.textcolor, fontSize: 10.sp),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "\$55 incl",
                              style: TextStyle(
                                  color: controller.colorPrimary, fontSize: 12.sp),
                            ),
                            Image.asset(
                              AssetPaths.verifiedIcon,
                              color: controller.colorPrimary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
