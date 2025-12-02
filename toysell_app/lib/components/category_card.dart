import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../MVC/model/categoryModel.dart';
import '../constant/theme.dart';
import 'image_widget.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.data}) : super(key: key);

  final CategoryModel data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return Container(
        width: 120,
        height: 160.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: ClipPath(
                clipper: BannerClipper(),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    gradient: themeController.backgroundGradient,
                  ),
                  child: Center(
                    child: ImageWidget(
                      height: 40.sp,
                      width: 40.sp,
                      imageUrl: data.icon ?? '',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  data.name.capitalize!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 2);
    path.lineTo(size.width / 2, size.height - 25);
    path.lineTo(size.width, size.height - 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}