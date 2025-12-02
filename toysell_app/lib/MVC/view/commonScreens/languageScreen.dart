import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/internet_controller.dart';
import 'package:toysell_app/services/local_storage.dart';

import '../../../services/localization_service.dart';

class Languagescreen extends StatefulWidget {
  const Languagescreen({super.key});

  @override
  State<Languagescreen> createState() => _LanguagescreenState();
}

class _LanguagescreenState extends State<Languagescreen> {
  final internetController = Get.put(InternetController());

  // Initialize the selected language based on the current locale
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Set initial selected language based on current locale
    _selectedLanguage = LocalDataStorage.lang.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
          value: themecontroller.systemUiOverlayStyleForwhite,
          child: SafeArea(
            child: Scaffold(
                backgroundColor: themecontroller.backgoundcolor,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                    surfaceTintColor: themecontroller.backgoundcolor,
                    backgroundColor: themecontroller.backgoundcolor,
                    centerTitle: true,
                    title: Text(
                      'language'.tr,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.sp),
                    )),
                body: Column(
                  children: [
                    languagetab(
                      imageUrl:
                          "https://media.istockphoto.com/id/983123698/photo/flag-of-sweden-waving-background.jpg?s=612x612&w=0&k=20&c=nGqDYqmOcHTHh2E8-mf7OJizVXyrjtTRxauVmrg2CUk=",
                      heading: "Swedish",
                      groupValue: _selectedLanguage,
                      value: "sv",
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                        LocalizationService.changeLocale('sv');
                        LocalDataStorage.getInstance.updateLang(value!);
                      },
                    ),
                    languagetab(
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRW7zHIAKEj1wzt95JYz8NRBAKxMVzwgOx-jCNwgHvQXUjzPlvM38gVZaActL0tUGsV6o&usqp=CAU",
                      heading: "English",
                      groupValue: _selectedLanguage,
                      value: "en",
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                        LocalizationService.changeLocale('en');
                        LocalDataStorage.getInstance.updateLang(value!);
                      },
                    ),
                  ],
                )),
          ));
    });
  }
}

class languagetab extends StatelessWidget {
  const languagetab({
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
            borderRadius: BorderRadius.circular(10.sp),
            color: isSelected ? themecontroller.colorPrimary : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 15.sp),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // CircleAvatar(
                      //   radius: 40,
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
      );}
    );
  }
}
