import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/wallet_controller.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';

import 'transactionHistoryScreen.dart';

class WalletScreen extends StatelessWidget {
  final themeHelper = Get.find<ThemeHelper>();
  final walletController = Get.put(WalletController())..onInit();

  WalletScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mockWithdrawnTransactions = [
      {
        "amount": "-250.00 kr",
        "date": "12 Dec 2024",
        "account": "****4447",
      },
      {
        "amount": "-250.00 kr",
        "date": "12 Dec 2024",
        "account": "****4447",
      },
    ];

    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: themecontroller.backgoundcolor,
            appBar: AppBar(
              backgroundColor: themecontroller.backgoundcolor,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              automaticallyImplyLeading: false,
              title: Text(
                'balance'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              shadowColor: Colors.transparent,
            ),
            body: Obx(
                () {
                  if (walletController.isLoading.value) {
                    return _buildShimmerPlaceholder();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Make Withdraw Button
                        ElevatedButton(
                          onPressed: () async {
                            final stripeAccId = "your_stripe_account_id_here";
                            final paymentIds = walletController.transactions.map((e) => e.id).toList();
                            if (paymentIds.isEmpty) {
                              Get.snackbar("Error", "No payments available for withdrawal");
                              return;
                            }
                            await walletController.submitWithdrawalRequest(
                              stripeAccountId: stripeAccId,
                              paymentIds: paymentIds,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themecontroller.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.sp),
                          ),
                          child: Center(
                            child: Text(
                              'make_withdraw'.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        // Balance Amount
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "balance".tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: themecontroller.textcolor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 18.sp),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(horizontal: 16.sp,vertical: 22.sp),
                                  decoration: BoxDecoration(
                                    color: themecontroller.bgcolor2,
                                    boxShadow: [
                                      BoxShadow(
                                        color: themecontroller.bgcolor,
                                        blurRadius: 2, // Amount of blur
                                        spreadRadius: 2,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "${walletController.walletAmount.value}\$",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 48.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins"
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Withdrawn and Pending Section
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Withdrawn Section
                              Text(
                                "withdrawn".tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: themecontroller.textcolor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.sp),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: themecontroller.bgcolor2,
                                    boxShadow: [
                                      BoxShadow(
                                        color: themecontroller.bgcolor,
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: walletController.withdraws.isEmpty
                                      ? Center(
                                    child: Text(
                                      "No withdrawals yet",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ) : ListView.separated(
                                    itemCount: walletController.withdraws.length,
                                    itemBuilder: (context, index) {
                                      final transaction = walletController.withdraws[index];
                                      return SpringWidget(
                                        onTap: () {},
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "withdraw_to_bank_account".tr,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.black.withOpacity(0.9),
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.sp),
                                                  Text(
                                                    transaction.createdAt.substring(0, 10),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.black.withOpacity(0.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "-${transaction.transferredAmount} ${transaction.currency.toUpperCase()}",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.sp),
                                                  Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 14.sp,
                                                    color: Colors.black.withOpacity(0.7),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => Divider(
                                      color: Colors.grey.withOpacity(0.3),
                                      thickness: 1,
                                      height: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.sp,),
                              // Pending Section
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       "pending".tr,
                              //       style: TextStyle(
                              //         fontSize: 16.sp,
                              //         color: themecontroller.textcolor,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //     SizedBox(height: 10.sp),
                              //     Container(
                              //       padding: EdgeInsets.symmetric(horizontal: 16.sp,vertical: 8.sp),
                              //       decoration: BoxDecoration(
                              //         color: themecontroller.bgcolor2,
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: themecontroller.bgcolor,
                              //             blurRadius: 2, // Amount of blur
                              //             spreadRadius: 2,
                              //             offset: Offset(0, 4),
                              //           ),
                              //         ],
                              //       ),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Text(
                              //             "starting_balance".tr,
                              //             style: TextStyle(
                              //               fontSize: 14.sp,
                              //               color: Colors.black.withOpacity(0.7),
                              //               fontWeight: FontWeight.w400,
                              //             ),
                              //           ),
                              //           Text(
                              //             "1000 kr",
                              //             style: TextStyle(
                              //               fontSize: 14.sp,
                              //               color: themecontroller.colorPrimary,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 18.sp,
                              // ),
                              // History Section
                              SpringWidget(
                                onTap: () {
                                  Navigation.getInstance.RightToLeft_PageNavigation(context, TransactionHistoryScreen());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                  decoration: BoxDecoration(
                                    color: themecontroller.bgcolor2,
                                    boxShadow: [
                                      BoxShadow(
                                        color: themecontroller.bgcolor,
                                        blurRadius: 2, // Amount of blur
                                        spreadRadius: 2,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "history".tr,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black.withOpacity(0.7),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(Icons.arrow_forward_ios_rounded,size: 14.sp,color: Colors.black.withOpacity(0.7),)
                                    ],
                                  ),
                                ),
                              ),
                              // Add more history transactions here if needed
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ),
        ),
      );
    });
  }
  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
          ),
          SizedBox(height: 20.sp),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 16.sp),
            ),
          ),
        ],
      ),
    );
  }


  void showWithdrawOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Withdrawal Method",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.sp),
              ListTile(
                leading: Icon(Icons.account_balance, color: themeHelper.colorPrimary),
                title: Text("bank_transfer".tr),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone_android, color: themeHelper.colorPrimary),
                title: Text("swish".tr),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.account_balance_wallet, color: themeHelper.colorPrimary),
                title: Text("paypal".tr),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
