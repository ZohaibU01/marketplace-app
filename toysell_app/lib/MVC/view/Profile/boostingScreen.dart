import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import '../../../components/payment_sheet.dart';
import '../../controller/boosting_controller.dart';

class BoostingScreen extends StatefulWidget {
  final ProductModel product;

  const BoostingScreen({super.key, required this.product});
  @override
  _BoostingScreenState createState() => _BoostingScreenState();
}

class _BoostingScreenState extends State<BoostingScreen> {
  final BoostingController boostingController = Get.put(BoostingController());
  String selectedBoost = "1"; // Default selected boost

  @override
  void initState() {
    super.initState();
    boostingController.fetchBoostingPackages();
  }

  @override
  Widget build(BuildContext context) {
    final themeHelper = Get.find<ThemeHelper>();

    return Scaffold(
      backgroundColor: themeHelper.bgcolor, // Light background
      appBar: AppBar(
        backgroundColor: themeHelper.bgcolor,
        leading: IconButton(
          icon: Icon(Icons.close, color: themeHelper.textcolor),
          onPressed: () {
            Navigation.getInstance
                .pagePushAndReplaceNavigation(context, BottomNavBar());
            // Navigator.pop(context);
            // Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Choose Your Boost',
          style: TextStyle(
            color: themeHelper.textcolor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        if (boostingController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (boostingController.boostingPackages.isEmpty) {
          return Center(
            child: Text(
              "No Boosting Packages Available",
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
            ),
          );
        }

        final boostingPackages = boostingController.boostingPackages;

        return Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Package List
              Expanded(
                child: ListView.builder(
                  itemCount: boostingPackages.length,
                  itemBuilder: (context, index) {
                    final package = boostingPackages[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (package["is_active"])
                                  Container(
                                    margin: EdgeInsets.only(bottom: 8.sp),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.sp,
                                      vertical: 4.sp,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeHelper.colorPrimary,
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                    child: Text(
                                      "Active Package",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                Text(
                                  package["name"] ?? "",
                                  style: TextStyle(
                                    color: themeHelper.textcolor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.sp),
                                Text(
                                  package["description"] ?? "",
                                  style: TextStyle(
                                    color:
                                        themeHelper.textcolor.withOpacity(0.6),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${package["final_price"]} USD",
                                style: TextStyle(
                                  color: themeHelper.textcolor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10.sp),
                              Radio<String>(
                                value: package["id"].toString() ?? "",
                                groupValue: selectedBoost,
                                onChanged: (value) {
                                  setState(() {
                                    selectedBoost = value!;
                                  });
                                },
                                activeColor: themeHelper.colorPrimary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Confirm Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedBoost.isEmpty) {
                      Get.snackbar("Error", "Please select a boost package.");
                      return;
                    }
                    var selectedPackage =
                        boostingController.boostingPackages.firstWhere(
                      (p) => p["id"].toString() == selectedBoost,
                    );
                    showPaymentBottomSheet(
                        context: context,
                        totalPrice:
                            (selectedPackage["price"] as int).toDouble(),
                        itemId: selectedPackage["id"],
                        currency: "USD",
                        token: "tok_visa",
                        customerId: 0,
                        saveCard: false,
                        onPaymentSuccess: (paymentMethodId) {
                          boostingController
                              .buyPackage(
                            packageId: int.parse(selectedBoost),
                            stripeToken: paymentMethodId,
                            itemId: widget.product.id,
                          )
                              .then((res) {
                            // productController.onInit();
                            // Get.snackbar(
                            //   "Success",
                            //   "Checkout completed successfully",
                            //   snackPosition: SnackPosition.BOTTOM,
                            // );
                            if (res) {
                              Navigation.getInstance
                                  .pagePushAndReplaceNavigation(
                                      context, BottomNavBar());
                              // Navigator.pop(context, true);
                              // Navigator.pop(context, true);
                              // Navigator.pop(context, true);
                            }
                          }).catchError((error) {
                            Get.snackbar(
                              "Error",
                              "Checkout failed: $error",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          });
                        },
                        onPaymentFailed: (_) {});
                    // Handle confirmation
                    Get.snackbar("Success", "Selected: $selectedBoost");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeHelper.colorPrimary,
                    padding: EdgeInsets.symmetric(vertical: 14.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  child: Text(
                    "Review Order - ${boostingController.boostingPackages.firstWhere(
                      (p) => p["id"].toString() == selectedBoost,
                    )["name"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
    CardFieldInputDetails? cardFieldInputDetails =
        const CardFieldInputDetails(complete: false);

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
