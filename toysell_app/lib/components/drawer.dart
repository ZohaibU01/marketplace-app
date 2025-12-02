import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/MVC/view/Profile/changePasswordScreen.dart';
import 'package:toysell_app/MVC/view/Profile/editProfileScreen.dart';
import 'package:toysell_app/MVC/view/loginScreen/SignInScreen.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class AppDrawer extends StatelessWidget {
  @override
  final _pref = DataStroge();

  AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Drawer(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide.none)),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/titleLogo.jpg',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Edit Profile',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigation.getInstance
                    .screenNavigation(context, EditProfileScreen());
              },
            ),
            ListTile(
              title: Text(
                'Change Password',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigation.getInstance
                    .screenNavigation(context, ChangePsswordScreen());
              },
            ),
            
            ListTile(
              title: Text(
                'Invite your friend',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigation.getInstance
                //     .screenNavigation(context, SharingScreen());
              },
            ),
            ListTile(
              title: Text(
                'Wishlist',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigation.getInstance
                //     .screenNavigation(context, wishlistScreen());
              },
            ),
            ListTile(
              title: Text(
                'Terms & Conditions',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Privacy & Policy',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Contact us',
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
              onTap: () {},
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.screenPadding,
                  vertical: Constants.screenPadding),
              child: RoundButton(
                gradient: false,
                margin: 0,
                backgroundColor: themecontroller.colorPrimary,
                height: 40.sp,
                title: 'Logout',
                icon: const Icon(Icons.logout_rounded),
                iconColor: themecontroller.colorwhite,
                textColor: themecontroller.colorwhite,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                          backgroundColor: themecontroller.backgoundcolor,
                          child: GetBuilder<ThemeHelper>(
                              builder: (themecontroller) {
                            return SizedBox(
                              height: 200.sp,
                              width: 300.sp,
                              child: Column(children: [
                                SizedBox(
                                  height: 50.sp,
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10.sp,
                                ),
                                Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.sp,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    RoundButton(
                                      width: 100.sp,
                                      backgroundColor:
                                          themecontroller.colorPrimary,
                                      borderColor: themecontroller.colorwhite,
                                      height: 40.sp,
                                      onTap: () async {
                                        await _pref.logout();
                                        Navigation.getInstance
                                            .pagePushAndReplaceNavigation(
                                                context, SignInScreen());
                                      },
                                      title: 'Login',
                                      gradient: false,
                                      textColor: themecontroller.colorwhite,
                                    ),
                                    RoundButton(
                                      width: 100.sp,
                                      backgroundColor:
                                          themecontroller.backgoundcolor,
                                      borderColor: themecontroller.colorPrimary,
                                      height: 40.sp,
                                      gradient: false,
                                      borderWidth: 1,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: 'Cancel',
                                      textColor: themecontroller.colorPrimary,
                                    ),
                                  ],
                                )
                              ]),
                            );
                          }));
                    },
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
