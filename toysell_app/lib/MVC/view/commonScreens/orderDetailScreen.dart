import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toysell_app/MVC/controller/order_controller.dart';
import 'package:toysell_app/MVC/controller/user_controller.dart';
import 'package:toysell_app/components/gradient_button.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant/theme.dart';
import '../../model/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final MyOrderModel order;
  final bool isMyShopOrder;
  final ThemeHelper themeHelper = Get.find<ThemeHelper>();
  OrderController orderController = Get.find<OrderController>();

  OrderDetailsScreen({super.key, required this.order, this.isMyShopOrder = false});

  @override
  Widget build(BuildContext context) {
    var user = Get.find<UserController>().users.firstWhere(
          (u) => u.id == order.buyerId,
        );
    return Scaffold(
      backgroundColor: themeHelper.colorwhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'Order#${order.id}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(text: 'Your Order is '),
                    TextSpan(
                      text: order.status.replaceAll("_", " "),
                      style:
                          TextStyle(color: themeHelper.colorPrimary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2),
              Text(
                DateFormat('d MMM yyyy, hh:mm a').format(DateTime.parse(order.createdAt)),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatus(),
            _buildAddressInfo(),
            SizedBox(
              height: 10.sp,
            ),
            _buildOrderSummary(),
            _buildPaymentInfo(),
            SizedBox(
              height: 10.sp,
            ),
            _buildSellerInfo(),
            SizedBox(
              height: 10.sp,
            ),
          ],
        ),
      ),
      bottomNavigationBar: (isMyShopOrder && order.status == "received"
          ? _buildOrderSetupButton(context, "Ready to Shipped")
          : (!isMyShopOrder && order.status == "ready_to_shipped"
              ? _buildOrderSetupButton(context, "Acknowledged")
              : null)),
    );
  }

  Widget _buildAddressInfo() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 12),
            decoration: BoxDecoration(
              color: themeHelper.greyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_shipping, color: themeHelper.colorPrimary),
                    SizedBox(width: 8),
                    Text('Address Info',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: themeHelper.colorPrimary)),
                  ],
                ),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: Icon(Icons.map, color: themeHelper.colorPrimary),
                //   label: Text('Show on map', style: TextStyle(color: themeHelper.colorPrimary)),
                // )
              ],
            ),
          ),
          SizedBox(
            height: 6.sp,
          ),
          _buildAddressSection('Shipping', order.shippingAddress.name, order.shippingAddress.phone,
              order.shippingAddress.shippingAddress),
          Divider(height: 1, color: themeHelper.bordercolor),
          _buildAddressSection('Billing', order.billingAddress.name, order.billingAddress.phone,
              order.billingAddress.billingAddress),
        ],
      ),
    );
  }

  Widget _buildAddressSection(String title, String name, String? phone, String address) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Icon(Icons.account_circle, color: themeHelper.colorPrimary),
              SizedBox(width: 8),
              Text(name),
              Spacer(),
              // IconButton(
              //   icon: Icon(Icons.edit, color: themeHelper.colorPrimary),
              //   onPressed: () {},
              // ),
              Text(phone ?? ''),
            ],
          ),
          Row(
            children: [
              title == "Shipping"
                  ? SvgPicture.asset(
                      AssetPaths.shippingAddress,
                      color: themeHelper.colorPrimary,
                      width: 24.sp,
                      height: 24.sp,
                    )
                  : SvgPicture.asset(
                      AssetPaths.billingAddress,
                      color: themeHelper.colorPrimary,
                      width: 24.sp,
                      height: 24.sp,
                    ),
              SizedBox(width: 8),
              Expanded(child: Text(address)),
            ],
          ),
        ],
      ),
    );
  }

  void _makeCall(String? phoneNumber) async {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      }
    }
  }

  Widget _buildOrderStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Verification Code: 74920', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 8),
        Text('Your Order is ${order.status.replaceAll("_", " ")}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(DateFormat('d MMM yyyy, hh:mm a').format(DateTime.parse(order.createdAt))),
        if (order.trackingId != null && order.trackingUrl != null)
          Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: GestureDetector(
              onTap: () async {
                final Uri trackingUri = Uri.parse(order.trackingUrl!);
                if (await canLaunchUrl(trackingUri)) {
                  await launchUrl(trackingUri, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar('Error', 'Could not open tracking link');
                }
              },
              child: Row(
                children: [
                  Icon(Icons.local_shipping, color: themeHelper.colorPrimary),
                  SizedBox(width: 8),
                  Text(
                    'Tracking ID: ${order.trackingId}',
                    style: TextStyle(
                      color: themeHelper.colorPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Divider(height: 20),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 6.sp,
        ),
        Card(
          child: ListTile(
            leading: Image.network(order.item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(order.item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: \$${order.price.toStringAsFixed(2)}'),

                // Text('Qty: 1'),
                // Text('Variations: Purple'),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sub Total'),
            Text('\$${order.price.toStringAsFixed(2)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Fee'),
            Text('\$0.00'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount'),
            Text('\$0.00'),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('\$${order.finalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Payment Status', style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Text(
              order.payment.status == 'succeeded' ? 'Paid' : 'Unpaid',
              style:
                  TextStyle(color: order.payment.status == 'succeeded' ? Colors.green : Colors.red),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(order.payment.brand, style: TextStyle(color: Colors.green)),
          ],
        ),
      ],
    );
  }

  Widget _buildSellerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isMyShopOrder ? 'Buyer Information' : 'Seller Information',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: order.seller.profile != null
                      ? ImageWidget(imageUrl: order.seller.profile!) as Widget
                      : SvgPicture.asset('assets/icons/user.svg') as Widget,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.seller.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, color: themeHelper.colorPrimary, size: 18),
                          SizedBox(width: 5),
                          Text(order.seller.mobile ?? ''),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.email, color: themeHelper.colorPrimary, size: 18),
                          SizedBox(width: 5),
                          Text(order.seller.email),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSetupButton(BuildContext context, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.0),
      child: GradientButton(
        label: status,
        onPressed: () {
          orderController.updateOrderStatus(order.id, status.toLowerCase().split(" ").join("_"));
        },
        width: double.maxFinite,
      ),
    );
  }

// void _sendEmail(String email) async {
//   final Uri emailUri = Uri(scheme: 'mailto', path: email);
//   if (await canLaunchUrl(emailUri)) {
//     await launchUrl(emailUri);
//   }
// }
//
// void _showUpdateStatusBottomSheet(BuildContext context) {
//   var statuses = ["Dispatched", "Delivered", "Received", ];
//   String? selectedStatus = statuses.firstWhereOrNull((st) => st.toLowerCase() ==  order.status,);
//   showModalBottomSheet(
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//
//       return Padding(
//         padding: EdgeInsets.all(16.sp),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Update Order Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 12.sp),
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               value: selectedStatus,
//               items: statuses
//                   .map((status) => DropdownMenuItem(
//                 value: status,
//                 child: Text(status),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 selectedStatus = value;
//               },
//             ),
//             SizedBox(height: 20.sp),
//             SizedBox(
//               width: double.infinity,
//               child: GradientButton(
//                 width: double.maxFinite,
//                 onPressed: () {
//                   if (selectedStatus != null) {
//                     orderController.updateOrderStatus(order.id, selectedStatus!);
//                     Navigator.pop(context);
//                   }
//                 },
//                 label: "Update",
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
}
