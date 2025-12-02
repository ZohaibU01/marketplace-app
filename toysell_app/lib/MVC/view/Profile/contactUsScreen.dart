import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactUsScreen extends StatelessWidget {
  final themeHelper = Get.find<ThemeHelper>();

  ContactUsScreen({
    super.key,
  });

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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                automaticallyImplyLeading: false,
                title: Text(
                  'contact_us'.tr,
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
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'how_can_we_help'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0.71,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'help_description'.tr,
                          style: TextStyle(
                            color: Color(0xFFB8B8B8),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.06,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 51.46,
                              height: 47.45,
                              decoration: ShapeDecoration(
                                color: themecontroller.colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x1E000000),
                                    blurRadius: 11,
                                    offset: Offset(0, 3),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: const Icon(Icons.phone_in_talk_rounded),
                            ),
                            const SizedBox(width: 16,),
                            Text(
                              'call'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0.71,
                              ),
                            ),
                          ],
                        ),
                        IconButton(onPressed: (){
                          _launchCaller();
                        }, icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 51.46,
                              height: 47.45,
                              decoration: ShapeDecoration(
                                color: themecontroller.colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x1E000000),
                                    blurRadius: 11,
                                    offset: Offset(0, 3),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: const Icon(Icons.email_rounded),
                            ),
                            const SizedBox(width: 16,),
                            const Text(
                              'email',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0.71,
                              ),
                            ),
                          ],
                        ),
                        IconButton(onPressed: (){
                          _sendEmail();
                        }, icon: const Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _launchCaller() async {
    const url = "tel:1234567";
    await launchUrlString(url);
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: "support@toysells.com",
      queryParameters: {
        'subject': "Write you subject here",
        'body': "Write your email body here.",
      },
    );

    await launchUrl(emailUri);
  }
}
