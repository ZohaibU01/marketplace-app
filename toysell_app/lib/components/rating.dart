import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toysell_app/components/spring_widget.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int totalStars;
  final Function() onTap;

  const StarRating({
    super.key,
    required this.rating,
    this.totalStars = 5,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SpringWidget(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalStars, (index) {
          return SvgPicture.asset(
            "assets/icons/star.svg",
            height: 20.sp,
            width: 20.sp,
            color: index < rating ? Colors.yellow : Colors.grey,
          );
        }),
      ),
    );
  }
}
