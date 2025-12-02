import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/controller/order_controller.dart';
import 'package:toysell_app/components/order_card_shimmer.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import '../../../components/oder_detail_card.dart';
import '../../model/my_shop_order_model.dart';
import '../../model/order_model.dart';
import '../commonScreens/orderDetailScreen.dart';

class MyShopOrderScreen extends StatelessWidget {
  MyShopOrderScreen({super.key});

  final orderController = Get.put(OrderController())..onInit();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return DefaultTabController(
        length: 7, // 6 statuses plus 'All'
        child: AnnotatedRegion(
          value: themecontroller.systemUiOverlayStyleForwhite,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: themecontroller.backgoundcolor,
              resizeToAvoidBottomInset: true,
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
                  'my_shop_orders'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      isScrollable: true,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 3),
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: themecontroller.greyColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      unselectedLabelColor: themecontroller.textcolor,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                      tabs: [
                        _buildTab('    All    ', themecontroller),
                        _buildTab('  Waiting Pickup ', themecontroller),
                        _buildTab('  In Transit ', themecontroller),
                        _buildTab(' Delivered ', themecontroller),
                        _buildTab(' Received ', themecontroller),
                        _buildTab(' Acknowledged ', themecontroller),
                        _buildTab(' Ready to Ship ', themecontroller),
                      ],
                    ),
                  ),
                ),
                shadowColor: Colors.transparent,
              ),
              body: Obx(() {
                if (orderController.isLoading.value) {
                  return _buildShimmerList();
                }

                return TabBarView(
                  children: [
                    _buildOrderList(orderController.shopOrders, 'All'),
                    _buildOrderList(
                        orderController.shopOrders
                            .where((order) => order.status == 'waiting_pickup')
                            .toList(),
                        'Waiting Pickup'),
                    _buildOrderList(
                        orderController.shopOrders
                            .where((order) => order.status == 'IN_TRANSIT')
                            .toList(),
                        'In Transit'),
                    _buildOrderList(
                        orderController.shopOrders
                            .where((order) => order.status == 'delivered')
                            .toList(),
                        'Delivered'),
                    _buildOrderList(
                        orderController.shopOrders
                            .where((order) => order.status == 'received')
                            .toList(),
                        'Received'),
                    _buildOrderList(
                        orderController.shopOrders
                            .where((order) => order.status == 'acknowledged')
                            .toList(),
                        'Acknowledged'),
                    _buildOrderList(
                        orderController.shopOrders
                            .where((order) => order.status == 'ready_to_shipped')
                            .toList(),
                        'Ready to Ship'),
                  ],
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTab(String name, ThemeHelper themecontroller) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
      color: themecontroller.colorwhite,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(width: 1, color: themecontroller.greyColor),
    ),
    child: Text(
      name,
      style: TextStyle(color: themecontroller.textcolor),
    ),
  );

  Widget _buildOrderList(List<MyShopOrderModel> orders, String status) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No $status orders found',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];
        return SpringWidget(
            onTap: () => Navigation.getInstance.RightToLeft_PageNavigation(
                context, OrderDetailsScreen(order: MyOrderModel.fromMyShopOrderModel(order),isMyShopOrder: true,)),
            child: OrderDetailsCard(order: order));
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const ShimmerOrderCard();
      },
    );
  }
}
