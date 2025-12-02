import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class bubble extends StatelessWidget {
  const bubble({
    super.key,
    required this.heading,
  });
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 246, 246),
          borderRadius: BorderRadius.circular(10.sp)),
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 2.sp),
      child: Text(
        heading,
        style: TextStyle(fontSize: 8.sp),
      ),
    );
  }
}