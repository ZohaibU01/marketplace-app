import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/constant/theme.dart';

class RatingScreen extends StatelessWidget {
  final List<dynamic> ratings;

  const RatingScreen({
    super.key,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(
      builder: (themecontroller) {
        return AnnotatedRegion(
          value: themecontroller.systemUiOverlayStyleforwhiteandtarnsparent,
          child: Scaffold(
            backgroundColor: themecontroller.backgoundcolor,
            appBar: AppBar(
              shadowColor: Colors.black,
              backgroundColor: themecontroller.backgoundcolor,
              surfaceTintColor: themecontroller.backgoundcolor,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                'User Rating',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: ratings.isEmpty
                ? Center(
              child: Text(
                "No ratings available.",
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              ),
            )
                : ListView.separated(
              padding: EdgeInsets.all(16.sp),
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final rating = ratings[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person, color: Colors.grey, size: 30.sp),
                            ),
                            SizedBox(width: 10.sp),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rating['reviewerName'] ?? "Anonymous",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.sp),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        Icons.star,
                                        color: starIndex < (rating['rating'] ?? 0)
                                            ? Colors.yellow
                                            : Colors.grey,
                                        size: 16.sp,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${rating['rating']} / 5",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.yellow[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.sp),
                        Text(
                          rating['review'] ?? "No review provided.",
                          style: TextStyle(fontSize: 12.sp, color: Colors.black.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 8.sp),
            ),
          ),
        );
      }
    );
  }
}
