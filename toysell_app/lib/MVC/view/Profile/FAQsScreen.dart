import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/constant/theme.dart';

import '../../controller/faqsController.dart';

class FAQsScreen extends StatelessWidget {
  final themeHelper = Get.find<ThemeHelper>();
  final faqsController = Get.put(FAQsController()..onInit());

  FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return DefaultTabController(
        length: 5,
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
                  'faqs_title'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp,
                  ),
                ),
                shadowColor: Colors.transparent,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await faqsController.fetchFAQs();
                  },
                  child: Obx(() {
                    if (faqsController.isLoading.value) {
                      return _buildShimmerLoading();
                    }

                    if (faqsController.faqsList.isEmpty) {
                      return Center(
                        child: Text(
                          "No FAQs available",
                          style: TextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: faqsController.faqsList.length,
                      itemBuilder: (context, index) {
                        final faq = faqsController.faqsList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FAQItem(
                            title: faq.question,
                            content: faq.answer,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Builds a shimmer effect for loading FAQs
  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 60.sp,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FAQItem extends StatefulWidget {
  final String title;
  final String content;

  const FAQItem({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362,
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                widget.content,
                style: const TextStyle(
                  color: Color(0xB7343434),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
