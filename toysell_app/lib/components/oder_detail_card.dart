import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../MVC/model/my_shop_order_model.dart';
import '../constant/theme.dart';

class OrderDetailsCard extends StatelessWidget {
  final MyShopOrderModel order;

  const OrderDetailsCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (controller) {
      return Container(
        width: double.infinity, // Make it responsive
        height: 120.sp, // Reduce height for smaller card
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Reduced margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Slightly smaller border radius
          boxShadow: const [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 8,
              offset: Offset(0, 3),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8), // Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // // Left Column
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Reduced padding
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           border: Border.all(width: 1, color: controller.greyColor),
              //         ),
              //         child: Text(
              //           'Order# ${order.id}',
              //           style: TextStyle(
              //             color: controller.textcolor,
              //             fontSize: 14.sp, // Reduced font size
              //             fontFamily: 'Poppins',
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 4.sp),
              //       Text(
              //         order.createdAt.split('T').first, // Extracting date
              //         style: TextStyle(
              //           color: controller.pink,
              //           fontSize: 14.sp, // Reduced font size
              //           fontFamily: 'Poppins',
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       SizedBox(height: 6.sp),
              //       Row(
              //         children: [
              //           CircleAvatar(
              //             radius: 20, // Reduced radius
              //             backgroundImage: NetworkImage(order.item.imageUrl),
              //             backgroundColor: Colors.transparent,
              //           ),
              //           SizedBox(width: 6.sp),
              //           Text(
              //             order.status.capitalizeFirst ?? 'Unknown',
              //             style: TextStyle(
              //               color: controller.colorPrimary,
              //               fontSize: 12.sp, // Reduced font size
              //               fontFamily: 'Poppins',
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // // Right Column
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Container(
              //         width: 90.sp, // Reduced width
              //         height: 38.sp, // Reduced height
              //         decoration: ShapeDecoration(
              //           color: controller.colorPrimary,
              //           shape: const RoundedRectangleBorder(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(6),
              //               topRight: Radius.circular(6),
              //               bottomLeft: Radius.circular(7),
              //               bottomRight: Radius.circular(6),
              //             ),
              //           ),
              //           shadows: const [
              //             BoxShadow(
              //               color: Color(0x1E000000),
              //               blurRadius: 8,
              //               offset: Offset(0, 3),
              //               spreadRadius: 0,
              //             )
              //           ],
              //         ),
              //         alignment: Alignment.center,
              //         child: Text(
              //           '\$${order.finalPrice.toStringAsFixed(2)}',
              //           style: TextStyle(
              //             fontSize: 14.sp, // Reduced font size
              //             fontFamily: 'Poppins',
              //             fontWeight: FontWeight.w600,
              //             color: controller.textcolor,
              //           ),
              //         ),
              //       ),
              //       Spacer(),
              //       Row(
              //         children: [
              //           Text(
              //             'Online Payment',
              //             style: TextStyle(
              //               color: controller.colorPrimary,
              //               fontSize: 12.sp, // Reduced font size
              //               fontFamily: 'Poppins',
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //           SizedBox(width: 6.sp),
              //           CircleAvatar(
              //             radius: 20, // Reduced radius
              //             backgroundImage: NetworkImage('https://cdn3.vectorstock.com/i/1000x1000/69/92/online-payment-icon-vector-6826992.jpg'),
              //             backgroundColor: Colors.transparent,
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: controller.greyColor),
                      ),
                      child: Text(
                        'Order# ${order.id}',
                        style: TextStyle(
                          color: controller.textcolor,
                          fontSize: 14.sp, // Reduced font size
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90.sp, // Reduced width
                      height: 38.sp, // Reduced height
                      decoration: ShapeDecoration(
                        color: controller.colorPrimary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x1E000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '\$${order.finalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp, // Reduced font size
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: controller.textcolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      order.createdAt.split('T').first, // Extracting date
                      style: TextStyle(
                        color: controller.pink,
                        fontSize: 14.sp, // Reduced font size
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20, // Reduced radius
                          backgroundImage: NetworkImage(order.item.imageUrl),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 6.sp),
                        Text(
                          order.status.replaceAll("_", " ").capitalizeFirst ?? 'Unknown',
                          style: TextStyle(
                            color: controller.colorPrimary,
                            fontSize: 12.sp, // Reduced font size
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          'Online Payment',
                          style: TextStyle(
                            color: controller.colorPrimary,
                            fontSize: 12.sp, // Reduced font size
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6.sp),
                        CircleAvatar(
                          radius: 20, // Reduced radius
                          backgroundImage: NetworkImage(
                              'https://cdn3.vectorstock.com/i/1000x1000/69/92/online-payment-icon-vector-6826992.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
