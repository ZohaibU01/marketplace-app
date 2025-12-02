import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/wallet_controller.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/wallet_controller.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/theme.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final themeHelper = Get.find<ThemeHelper>();
  final walletController = Get.put(WalletController())..fetchTransactions();

  TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              title: Text(
                "transaction_history_title".tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              shadowColor: Colors.transparent,
            ),
            body: Obx(() {
              if (walletController.isLoading.value) {
                return _buildShimmerList(themecontroller);
              }

              final transactions = walletController.transactions;

              if (transactions.isEmpty) {
                return Center(
                  child: Text(
                    "no_transactions".tr,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
                child: ListView.separated(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    Color statusColor;

                    switch (transaction.status) {
                      case "Pending":
                        statusColor = Colors.orange;
                        break;
                      case "Approved":
                        statusColor = themecontroller.colorPrimary;
                        break;
                      case "Rejected":
                        statusColor = themecontroller.redColor;
                        break;
                      default:
                        statusColor = Colors.black;
                    }

                    return SpringWidget(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: themecontroller.bgcolor2,
                          borderRadius: BorderRadius.circular(10.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.status.capitalize ??
                                      "status_${transaction.status.toLowerCase()}".tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.sp),
                                Text(
                                  "*****${transaction.payment.lastFour} - ${formatDate(transaction.createdAt)}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${transaction.finalPrice} ${transaction.payment.currency}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10.sp),
                ),
              );
            }),
          ),
        ),
      );
    });
  }

  Widget _buildShimmerList(ThemeHelper themecontroller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
      child: ListView.separated(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: themecontroller.bgcolor2,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.sp,
                        height: 14.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8.sp),
                      Container(
                        width: 150.sp,
                        height: 12.sp,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Container(
                    width: 80.sp,
                    height: 14.sp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10.sp),
      ),
    );
  }

  String formatDate(String dateString) {
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('dd MMM yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }
}

