import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductCard extends StatelessWidget {
  const ShimmerProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(5.sp),
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.grey.withOpacity(0.2),
        //       blurRadius: 5,
        //       spreadRadius: 1,
        //     ),
        //   ],
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header (User Info and Like Button)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12.sp,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      SizedBox(width: 10.sp),
                      Container(
                        width: 80.sp,
                        height: 12.sp,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  // Container(
                  //   width: 24.sp,
                  //   height: 24.sp,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade300,
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                ],
              ),
            ),

            /// Body (Product Image)
            Expanded(
              flex: 6,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.sp),
                  color: Colors.grey.shade300,
                ),
              ),
            ),

            /// Footer (Product Name and Price)
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product Name Placeholder
                    Container(
                      width: double.infinity,
                      height: 12.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 5.sp),

                    /// Price Placeholder
                    Container(
                      width: 60.sp,
                      height: 10.sp,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: 5.sp),

                    /// Discount and Verified Placeholder
                    Row(
                      children: [
                        Container(
                          width: 40.sp,
                          height: 10.sp,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(width: 5.sp),
                        Container(
                          width: 16.sp,
                          height: 16.sp,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
