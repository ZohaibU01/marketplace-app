import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/view/commonScreens/orderDetailScreen.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import '../../controller/order_controller.dart';
import '../../model/order_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/theme.dart';
import '../../controller/order_controller.dart';
import '../../model/order_model.dart';

class MyOrderScreen extends StatefulWidget {
  MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final themeController = Get.find<ThemeHelper>();
  final orderController = Get.put(OrderController());

  @override
  void initState() {
    orderController.fetchMyOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      init: OrderController()..fetchMyOrders(),
      builder: (orderController) {
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
                title: Text(
                  "my_orders_title".tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              body: Obx(() {
                if (orderController.isLoading.value) {
                  return _buildShimmerList();
                }

                if (orderController.orders.isEmpty) {
                  return Center(
                    child: Text(
                      "no_orders_found".tr,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orderController.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    var order = orderController.orders[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrderCard(
                        order: order,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Display shimmer for 5 items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 90.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
  });

  final MyOrderModel order;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return SpringWidget(
        onTap: () {
          Navigation.getInstance.RightToLeft_PageNavigation(context, OrderDetailsScreen(order: order));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 90.sp,
                width: 90.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.sp),
                  color: themecontroller.colorPrimary,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.sp),
                  child: ImageWidget(imageUrl: order.item.imageUrl),
                ),
              ),
              SizedBox(width: 5.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100.sp,
                          child: Text(
                            "order_id".tr + order.id.toString(),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: order.status == "paid"
                                ? themecontroller.colorPrimary
                                : themecontroller.greyColor,
                            borderRadius: BorderRadius.circular(20.sp),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.sp,
                            vertical: 5.sp,
                          ),
                          child: Text(
                            order.status.replaceAll("_", " ").capitalizeFirst.toString(),
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                              color: themecontroller.bgcolor,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 150.sp,
                      child: Text(
                        order.createdAt,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.sp),
                    SizedBox(
                      width: 100.sp,
                      child: Text(
                        "${Constants.currency} ${order.price}",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: themecontroller.colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
