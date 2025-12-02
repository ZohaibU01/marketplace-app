import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/controller/productController.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/MVC/view/commonScreens/productDetailScreen.dart';
import 'package:toysell_app/constant/navigation.dart';

import '../MVC/model/categoryModel.dart';
import '../constant/theme.dart';
import 'image_widget.dart';

class ProductChatCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String price;
  final String priceDetail;
  final String iconUrl;
final int item_id;
  ProductChatCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.priceDetail,
    required this.iconUrl, required this.item_id,
  });

  @override
  final productController = Get.put(ProductController());
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (controller) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // var tempProduct = ProductModel(
          //   id: 1,
          //   name: 'Product name',
          //   description:
          //   'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since.',
          //   price: 89.99,
          //   imageUrl:
          //   'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg', // Using the first image as the main image
          //   images: [
          //     'https://i.etsystatic.com/23883117/r/il/130519/2846519551/il_570xN.2846519551_ck9y.jpg',
          //     'https://i.etsystatic.com/24971278/r/il/ad3f68/3244436294/il_1080xN.3244436294_7jtm.jpg',
          //   ],
          //   category: CategoryModel(
          //     id: 101,
          //     name: 'Accessories',
          //     status: 1,
          //   ), // Updated to use CategoryModel
          //   subCategory: CategoryModel(
          //     id: 102,
          //     name: 'Bags',
          //     status: 1,
          //   ), // Updated to use CategoryModel
          //   slug: 'product-name', // Added a slug
          //   videoLink: null, // Assuming no video link
          //   address: '123 Main Street, Anytown, USA', // Placeholder address
          //   latitude: 40.7128, // Placeholder latitude (New York City)
          //   longitude: -74.0060, // Placeholder longitude (New York City)
          //   isPremium: true, // Assuming the product is premium
          //   contact: '123-456-7890', // Placeholder contact
          //   country: 'USA', // Placeholder country
          //   state: 'New York', // Placeholder state
          //   city: 'New York City', // Placeholder city
          //   sellerName: 'Seller Name',
          //   sellerPicture:
          //   'https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8fDA%3D',
          //   rating: 10,
          // );
          // Navigation.getInstance.RightToLeft_PageNavigation(context, ProductDetailScreen(data: tempProduct));
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10.sp, bottom: 8.sp, top: 8.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 55,
                height: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: ImageWidget(
                  imageUrl: imageUrl,
                  height: 50.sp,
                  width: 50.sp,
                ),
              ),
              const SizedBox(width: 8),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      productName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 0), // Spacing between name and price
                    // Price and Icon Row
                    Row(
                      children: [
                        // Price Details
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: price,
                                style: TextStyle(
                                  color: controller.colorPrimary,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const TextSpan(
                                text: ' ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: priceDetail,
                                style: TextStyle(
                                  color: controller.colorPrimary,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Spacing between price and icon
                        // Icon
                        Image.asset(
                          iconUrl,
                          color: controller.colorPrimary,
                          width: 11,
                          height: 11,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  var data = productController.products
                      .where(
                        (e) => e.id == item_id,
                      )
                      .first;
                  print(data);
                  Navigation.getInstance.bottomToTop_PageNavigation(
                      context, ProductDetailScreen(data: data));
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: controller.greyColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
