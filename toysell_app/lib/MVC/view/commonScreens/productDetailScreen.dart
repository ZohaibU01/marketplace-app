import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:toysell_app/MVC/controller/user_controller.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/MVC/view/commonScreens/chatScreen.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/flutter_toast.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:toysell_app/services/local_storage.dart';
import '../../../components/expandable_text.dart';
import '../../../components/payment_sheet.dart';
import '../../../components/rating.dart';
import '../../../helper/internet_controller.dart';
import '../../../helper/popup_helper.dart';
import '../../controller/productController.dart';
import '../Profile/ratingScreen.dart';
import 'checkoutScreen.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({
    super.key,
    required this.data,
  });

  final ProductModel data;
  final internetController = Get.put(InternetController());
  final productController = Get.put(ProductController());
  final userController = Get.put(UserController())..fetchAllUsers();

  @override
  RxBool showmessageBox = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      var user = userController.users.firstWhere(
        (u) => u.id == data.userId,
      );
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleforwhiteandtarnsparent,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 400.sp,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListWheelScrollViewX(
                                itemExtent: 400.sp,
                                scrollDirection: Axis.horizontal,
                                children: data.images
                                    .map(
                                      (e) => Hero(
                                        tag: 'product-image${data.id}',
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 600.sp,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.sp)),
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.sp),
                                                child: ImageWidget(imageUrl: e),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 10.sp,
                                              right: 30.sp,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.sp)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.image_outlined,
                                                        size: 15.sp,
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                      ),
                                                      Text(
                                                        data.images.length
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 8.sp,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40.sp,
                        left: 10.sp,
                        child: SpringWidget(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: themecontroller.bgcolor,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Positioned(
                            top: 40.sp,
                            right: 20.sp,
                            child: SpringWidget(
                              onTap: data.userId ==
                                      DataStroge.currentUser.value!.id
                                  ? () {}
                                  : () {
                                      productController
                                          .addOrRemoveFavouriteProduct(data.id);
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.sp, vertical: 1.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.sp),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      (productController.isInFavourite(data.id))
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: (productController
                                              .isInFavourite(data.id))
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
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Constants.screenPadding,
                        vertical: Constants.screenPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.sp),
                            child: ImageWidget(
                              imageUrl: data.sellerPicture ?? "",
                              height: 50.sp,
                              width: 50.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200.sp,
                              child: Text(
                                textAlign: TextAlign.start,
                                user.name,
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                            StarRating(
                              rating: user.averageRating ?? 0,
                              onTap: () {
                                Navigation.getInstance
                                    .RightToLeft_PageNavigation(context,
                                        RatingScreen(ratings: user.ratings));
                              },
                            ),
                            // Row(
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
                            //     Text(
                            //       "(${5.0})",
                            //       style: TextStyle(fontSize: 12.sp),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                    thickness: 2.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.screenPadding.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Constants.currency}${data.price}",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.sp),
                        Text(
                          data.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        ExpandableText(
                          text: data.description,
                          trimLines: 3,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.screenPadding,
                  vertical: Constants.screenPadding),
              child: data.userId == DataStroge.currentUser.value!.id
                  ? const SizedBox()
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RoundButton(
                            margin: 0,
                            titleSize: 10.sp,
                            height: 40.sp,
                            gradient: true,
                            borderRadius: 20.sp,
                            title: 'buy_now'.tr,
                            textColor: themecontroller.colorPrimary,
                            onTap: () {
                              Navigation.getInstance.bottomToTop_PageNavigation(
                                  context,
                                  CheckoutScreen(
                                    product: data,
                                  ));
                              // showPaymentBottomSheet(
                              //   context: context,
                              //   totalPrice: data.price,
                              //   itemId: data.id,
                              //   currency: "USD",
                              //   token: "tok_visa",
                              //   // Replace with the actual token from Stripe
                              //   customerId: data.userId,
                              //   saveCard: true,
                              //   // Assuming a save card option
                              //   onPaymentSuccess: () {
                              //
                              //
                              //     productController
                              //         .checkout(
                              //       itemId: data.id,
                              //       amount: data.price,
                              //       currency: "USD",
                              //       token: "tok_visa",
                              //       customerId: data.userId,
                              //       save: true,
                              //     )
                              //         .then((_) {
                              //       productController.onInit();
                              //       // Get.snackbar(
                              //       //   "Success",
                              //       //   "Checkout completed successfully",
                              //       //   snackPosition: SnackPosition.BOTTOM,
                              //       // );
                              //       Navigator.pop(context, true);
                              //     }).catchError((error) {
                              //       Get.snackbar(
                              //         "Error",
                              //         "Checkout failed: $error",
                              //         snackPosition: SnackPosition.BOTTOM,
                              //       );
                              //     });
                              //   },
                              //   onPaymentFailed: (error) {
                              //     Get.snackbar(
                              //       "Error",
                              //       "Payment failed: $error",
                              //       snackPosition: SnackPosition.BOTTOM,
                              //     );
                              //   },
                              // );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Expanded(
                          flex: 1,
                          child: Obx(
                            () => RoundButton(
                              margin: 0,
                              loading: productController.chatloading.value,
                              disabled: productController.chatloading.value,
                              titleSize: 10.sp,
                              height: 40.sp,
                              gradient: false,
                              borderColor: themecontroller.colorPrimary,
                              borderWidth: 2.sp,
                              borderRadius: 20.sp,
                              title: 'chat_now'.tr,
                              textColor: themecontroller.colorPrimary,
                              onTap: () async {
                                // if (data.itemOffers
                                //     .where(
                                //       (e) =>
                                //           e.buyerId ==
                                //           DataStroge.currentUser.value?.id,
                                //     )
                                //     .isNotEmpty) {
                                // var offe

                                await productController.GetSingleChat(
                                    item_id: data.id,
                                    // item_Offer_id: offer_Id,
                                    type: "buyer");
                                if (productController.messages.isNotEmpty) {
                                  Navigation.getInstance
                                      .bottomToTop_PageNavigation(
                                          context,
                                          ChatScreen(
                                            chatModel:
                                                productController.messages[0],
                                            isBuyer: true,
                                          ));
                                }
                                // } else {
                                //   FlutterToastDisplay.getInstance
                                //       .showToast("Please make an offer first");
                                // }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Expanded(
                          flex: 1,
                          child: RoundButton(
                            margin: 0,
                            titleSize: 10.sp,
                            height: 40.sp,
                            gradient: false,
                            borderColor: themecontroller.colorPrimary,
                            borderWidth: 2.sp,
                            borderRadius: 20.sp,
                            title: 'make_an_offer'.tr,
                            textColor: themecontroller.colorPrimary,
                            onTap: () {
                              PopupHelper.showOfferPopup(
                                context: context,
                                sellerPrice:
                                    data.price, // Pass the dynamic sellerPrice
                                onSend: (offer) {
                                  // Call the `makeOffer` method from ProductController
                                  productController
                                      .makeOffer(itemId: data.id, amount: offer)
                                      .then((res) {
                                    if (res) {
                                      Navigator.pop(context);
                                    }
                                  }).catchError((error) {
                                    Get.snackbar(
                                      "Error",
                                      "Failed to send offer: $error",
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}
