import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/controller/productController.dart';
import 'package:toysell_app/helper/data_storage.dart';
import '../../../components/payment_sheet.dart';
import '../../../components/round_button.dart';
import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../MVC/controller/checkout_controller.dart';
import '../../../MVC/model/productModel.dart';
import 'manageAddressScreen.dart';

class CheckoutScreen extends StatelessWidget {
  final ProductModel product;

  CheckoutScreen({super.key, required this.product});

  final checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return AnnotatedRegion(
        value: themeController.systemUiOverlayStyleForwhite,
        child: Scaffold(
          backgroundColor: themeController.backgoundcolor,
          appBar: AppBar(
            title: Text(
              "Checkout",
              style: TextStyle(color: themeController.textcolor, fontSize: 18.sp),
            ),
            backgroundColor: themeController.backgoundcolor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: themeController.textcolor),
            ),
          ),
          body: Obx(() =>
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Constants.screenPadding, vertical: Constants.screenPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Details Section
                      _buildProductDetailsCard(themeController, product),
                      SizedBox(height: 20.sp),

                      // Billing Address
                      Text(
                        "Billing Address",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: themeController.textcolor,
                        ),
                      ),
                      SizedBox(height: 6.sp,),
                      _buildAddressCard(
                        themeController,
                        address: checkoutController.billingAddress.value,
                        onEdit: () async {
                          final selectedAddress = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ManageAddressScreen()),
                          );
                          if (selectedAddress != null) {
                            checkoutController.billingAddress.value = selectedAddress;
                          }
                        },
                      ),
                      SizedBox(height: 10.sp),

                      // Shipping Address
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: checkoutController.sameAsBilling.value,
                                  onChanged: (value) {
                                    checkoutController.toggleSameAsBilling(value ?? false);
                                  },
                                ),
                                Text(
                                  "Shipping address same as billing",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: themeController.textcolor),
                                ),
                              ],
                            ),
                            if (!checkoutController.sameAsBilling.value)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shipping Address",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: themeController.textcolor,
                                    ),
                                  ),
                                  SizedBox(height: 6.sp,),
                                  _buildAddressCard(
                                    themeController,
                                    address: checkoutController.shippingAddress.value,
                                    onEdit: () async {
                                      final selectedAddress = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ManageAddressScreen()),
                                      );
                                      if (selectedAddress != null) {
                                        checkoutController.shippingAddress.value = selectedAddress;
                                      }
                                    },
                                  ),
                                ],
                              ),
                          ],
                        );
                      }),
                      SizedBox(height: 20.sp),

                      // Payment Option
                      Text(
                        "Payment Option",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: themeController.textcolor,
                        ),
                      ),
                      ListTile(
                        title: Text("Online Payment"),
                        leading: Radio(
                          value: "online",
                          groupValue: checkoutController.paymentMethod.value,
                          onChanged: (value) {
                            checkoutController.setPaymentMethod(value ?? "online");
                          },
                        ),
                      ),
                      SizedBox(height: 20.sp),
                    ],
                  ),
                ),
              ),),
          bottomNavigationBar: Obx(
                () =>
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Constants.screenPadding, horizontal: 2.sp),
                  child: RoundButton(
                    title: "Place Order",
                    height: 50.sp,
                    loading: checkoutController.isLoading.value,
                    gradient: true,
                    borderRadius: 20.sp,
                    onTap: () {
                      var productController = Get.find<ProductController>();
                      showPaymentBottomSheet(context: context,
                          totalPrice: product.price,
                          itemId: product.id,
                          currency: "USD",
                          token: "tok_visa",
                          customerId: product.userId,
                          saveCard: false,
                          onPaymentSuccess: (paymentMethodId) {
                            checkoutController
                                .checkout(
                              itemId: product.id,
                              amount: product.price,
                              currency: "USD",
                              token: paymentMethodId,
                              customerId: DataStroge.currentUser.value!.id,
                              save: true,
                              address: checkoutController.billingAddress.value,
                              shippingAddress: checkoutController.shippingAddress.value,
                            )
                                .then((_) {
                              productController.onInit();
                              // Get.snackbar(
                              //   "Success",
                              //   "Checkout completed successfully",
                              //   snackPosition: SnackPosition.BOTTOM,
                              // );
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            }).catchError((error) {
                              Get.snackbar(
                                "Error",
                                "Checkout failed: $error",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            });
                          },
                          onPaymentFailed: (_){});

                      // checkoutController.placeOrder(product);
                    },
                  ),
                ),
          ),
        ),
      );
    });
  }

  Widget _buildProductDetailsCard(ThemeHelper themeController, ProductModel product) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: themeController.greyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: themeController.textcolor,
            ),
          ),
          SizedBox(height: 10.sp),
          Text(
            "${Constants.currency}${product.price}",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: themeController.colorPrimary,
            ),
          ),
          SizedBox(height: 10.sp),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.sp),
            child: Image.network(
              product.images.first,
              height: 150.sp,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.sp),
          Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              color: themeController.textcolor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ThemeHelper themeController, {
    required String address,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: themeController.greyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              address,
              style: TextStyle(fontSize: 14.sp, color: themeController.textcolor),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: themeController.colorPrimary),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  void showPaymentBottomSheet({
    required BuildContext context,
    required double totalPrice,
    required int itemId,
    required String currency,
    required String token,
    required int customerId,
    required bool saveCard,
    required Function(String) onPaymentSuccess,
    required Function(String) onPaymentFailed,
  }) {
    CardFieldInputDetails? cardFieldInputDetails = const CardFieldInputDetails(complete: false);

    Get.bottomSheet(
      PaymentBottomSheet(
        totalAmount: totalPrice,
        onPaymentSuccess: (paymentMethodId) {
          onPaymentSuccess(paymentMethodId);
        },
        // onPaymentFailed: (error) {
        //   onPaymentFailed(error);
        // },
        onCardChanged: (cardDetails) {
          cardFieldInputDetails = cardDetails;
        },
      ),
    );
  }
}
