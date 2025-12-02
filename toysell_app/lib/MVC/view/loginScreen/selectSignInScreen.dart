import 'package:flutter_svg/svg.dart';
import 'package:toysell_app/MVC/view/commonScreens/languageScreen.dart';
import 'package:toysell_app/MVC/view/home/homeScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/authenticationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/MVC/view/loginScreen/signupScreen.dart';
import 'package:toysell_app/components/BottomNav.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:get/get.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../../../services/local_storage.dart';
import '../../../services/localization_service.dart';

class Selectsigninscreen extends StatefulWidget {
  Selectsigninscreen({super.key});

  @override
  State<Selectsigninscreen> createState() => _SelectsigninscreenState();
}

class _SelectsigninscreenState extends State<Selectsigninscreen> {

  final RxBool showlanguage = false.obs;

  // Initialize the selected language based on the current locale
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    DataStroge.setOnboardingFalse();
    // Set initial selected language based on current locale
    selectedLanguage = LocalDataStorage.lang.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(
      initState: (state) async {},
      builder: (themecontroller) {
        return AnnotatedRegion(
          value: themecontroller.systemUiOverlayStylefortarnsparent,
          child: Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                // Background container with decoration
                Container(
                  decoration: BoxDecoration(
                    
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/image.jpg"),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showlanguage.value = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                // Positioned widget for the button row
                Positioned(
                  top: 40.sp,
                  left: 10.sp,
                  child: SpringWidget(
                    onTap: () {
                      showlanguage.value = !showlanguage.value;
                    },
                    child: Icon(
                      Icons.language,
                      size: 30.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 40.sp,
                  right: 14.sp,
                  child: SpringWidget(
                    onTap: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(context, BottomNavBar());
                    },
                    child: Text(
                      'skip'.tr,
                      style: TextStyle(
                        color: themecontroller.colorPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 70.sp,
                  left: 0.sp,
                  right: 0.sp,
                  child: Obx(
                        () => Visibility(
                      visible: showlanguage.value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.sp),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 30.sp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                                child: Center(
                                  child: Text(
                                    'language'.tr,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.sp),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
                                child: Column(
                                  children: [
                                    langtab(
                                      imageUrl:
                                      "https://media.istockphoto.com/id/983123698/photo/flag-of-sweden-waving-background.jpg?s=612x612&w=0&k=20&c=nGqDYqmOcHTHh2E8-mf7OJizVXyrjtTRxauVmrg2CUk=",
                                      heading: 'swedish'.tr,
                                      groupValue: selectedLanguage,
                                      value: "sv",
                                      onChanged: (value) {
                                        selectedLanguage = value!;
                                        LocalizationService.changeLocale("sv");
                                        LocalDataStorage.getInstance.updateLang(value);
                                      },
                                    ),
                                    langtab(
                                      imageUrl:
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRW7zHIAKEj1wzt95JYz8NRBAKxMVzwgOx-jCNwgHvQXUjzPlvM38gVZaActL0tUGsV6o&usqp=CAU",
                                      heading: 'english'.tr,
                                      groupValue: selectedLanguage,
                                      value: "en",
                                      onChanged: (value) {
                                        selectedLanguage = value!;
                                        LocalizationService.changeLocale("en");
                                        LocalDataStorage.getInstance.updateLang(value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30.sp,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SpringWidget(
                            onTap: () {
                              Navigation.getInstance.pagePushAndReplaceNavigation(context, AuthenticationScreen());
                            },
                            child: Container(
                              height: 40.sp,
                              width: 100.sp,
                              decoration: BoxDecoration(
                                border: Border.all(color: themecontroller.colorPrimary, width: 2.sp),
                                borderRadius: BorderRadius.circular(30.sp),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'login'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: themecontroller.colorPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.sp),
                                      child: SvgPicture.asset(
                                        'assets/icons/arrowup.svg',
                                        width: 10.sp,
                                        height: 10.sp,
                                        color: themecontroller.colorPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.sp),
                        Expanded(
                          flex: 1,
                          child: SpringWidget(
                            onTap: () {
                              Navigation.getInstance.pagePushAndReplaceNavigation(context, SignupScreen());
                            },
                            child: Container(
                              height: 40.sp,
                              width: 100.sp,
                              decoration: BoxDecoration(
                                gradient: themecontroller.backgroundGradient,
                                borderRadius: BorderRadius.circular(30.sp),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'sign_up'.tr,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.sp),
                                      child: SvgPicture.asset(
                                        'assets/icons/arrowup.svg',
                                        width: 10.sp,
                                        height: 10.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class langtab extends StatelessWidget {
  const langtab({
    super.key,
    required this.imageUrl,
    required this.heading,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String imageUrl;
  final String heading;
  final String groupValue;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;

    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return SpringWidget(
        onTap: () {
          onChanged(value);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            color: Colors.white,
          ),
          // margin: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 15.sp),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 1.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // CircleAvatar(
                      //   radius: 20,
                      //   backgroundImage: NetworkImage(imageUrl),
                      // ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Text(
                        heading,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Radio<String>(
                    value: value,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: Colors.black,
                  ),
                ],
              )),
        ),
      );
    });
  }
}
