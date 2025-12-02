import 'package:toysell_app/MVC/controller/homeController.dart';
import 'package:toysell_app/MVC/view/commonScreens/conversationScreen.dart';
import 'package:toysell_app/MVC/view/home/allCategoriesList.dart';
import 'package:toysell_app/MVC/view/home/homeScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:toysell_app/MVC/view/Profile/ProfileScreen.dart';
import 'package:toysell_app/MVC/view/sell/select_categoryScreen.dart';
import 'package:toysell_app/components/custom_appbar.dart';
import 'package:toysell_app/components/drawer.dart';
import 'package:get/get.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/helper/data_storage.dart';
import '../constant/theme.dart';

class BottomNavBar extends StatefulWidget {
  final int? initialIndex;

  const BottomNavBar({super.key, this.initialIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = widget.initialIndex ?? _currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(
      builder: (themeController) => AnnotatedRegion(
        value: themeController.systemUiOverlayStyleForwhite,
        child: Scaffold(
          extendBody: true,
          body: _buildPage(_currentIndex),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Material(
              elevation: 0.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                currentIndex: _currentIndex,
                selectedIconTheme: IconThemeData(
                  color: themeController.colorPrimaryBlue,
                ),
                unselectedIconTheme: IconThemeData(
                  color: themeController.bottomiconcolor,
                ),
                selectedItemColor: themeController.colorPrimary,
                unselectedItemColor: themeController.bottomiconcolor,
                selectedLabelStyle: TextStyle(
                  color: themeController.colorPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
                unselectedLabelStyle: TextStyle(
                  color: themeController.bottomiconcolor,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                ),
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                        themeController, AssetPaths.homeIconSVG, 0),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                        themeController, AssetPaths.searchIconSVG, 1),
                    label: 'search'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                        themeController, AssetPaths.sellIconSVG, 2),
                    label: 'sell'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                        themeController, AssetPaths.chatsIconSVG, 3),
                    label: 'chat'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                        themeController, AssetPaths.profileIconSVG, 4),
                    label: 'profile'.tr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(
      ThemeHelper themeController, String assetPath, int index) {
    return Container(
      decoration: BoxDecoration(
        color: _currentIndex == index
            ? themeController.colorPrimary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          assetPath,
          height: _currentIndex == index ? 17.sp : 15.sp,
          width: _currentIndex == index ? 17.sp : 15.sp,
          color: themeController.colorPrimary,
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Homescreen();
      case 1:
        return AllCategoriesList();
      case 2:
        return SelectCategoryScreen();
      case 3:
        return ConversationScreen();
      case 4:
        return ProfileScreen(
          isSelf: true,
          userId: DataStroge.currentUser.value!.id,
        );
      default:
        return Homescreen();
    }
  }
}

