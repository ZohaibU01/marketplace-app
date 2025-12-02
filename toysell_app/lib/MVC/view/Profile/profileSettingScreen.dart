import 'package:toysell_app/MVC/controller/login_controller.dart';
import 'package:toysell_app/MVC/model/userModel.dart';
import 'package:toysell_app/MVC/view/Profile/FAQsScreen.dart';
import 'package:toysell_app/MVC/view/Profile/helpCenterScreen.dart';
import 'package:toysell_app/MVC/view/Profile/ratingScreen.dart';
import 'package:toysell_app/MVC/view/Profile/transactionHistoryScreen.dart';
import 'package:toysell_app/MVC/view/Profile/walletScreen.dart';
import 'package:toysell_app/MVC/view/myOrder/myShopOrderScreen.dart';
import 'package:toysell_app/MVC/view/commonScreens/languageScreen.dart';
import 'package:toysell_app/MVC/view/myOrder/myOrderScreen.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/popup_helper.dart';
import '../loginScreen/authenticationScreen.dart';
import 'contactUsScreen.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key, required this.user});

  final UserModel user;

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
                backgroundColor: themecontroller.backgoundcolor,
                centerTitle: true,
                title: Text(
                  'my_profile'.tr,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.sp),
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                automaticallyImplyLeading: false,
              ),
              body: ListView(
                children: [
                  settingtab(
                    heading: 'transaction_history'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.transaction,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, TransactionHistoryScreen());
                    },
                  ),
                  settingtab(
                    heading: 'my_order'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.myOrders,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, MyOrderScreen());
                    },
                  ),
                  settingtab(
                    heading: 'my_reviews'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.myReviews,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, RatingScreen(ratings: user.ratings));
                    },
                  ),
                  settingtab(
                    heading: 'language'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.language,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, Languagescreen());
                    },
                  ),
                  settingtab(
                    heading: 'faqs'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.faqs,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, FAQsScreen());
                    },
                  ),
                  settingtab(
                    heading: 'my_shop_order'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.myShopOrder,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, MyShopOrderScreen());
                    },
                  ),
                  settingtab(
                    heading: 'my_wallet'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.myWallet,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, WalletScreen());
                    },
                  ),
                  settingtab(
                    heading: 'contact_us'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.contactUs,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, ContactUsScreen());
                    },
                  ),
                  settingtab(
                    heading: 'about_us'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.aboutUs,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                  ),
                  settingtab(
                    heading: 'help_center'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.helpCenter,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      Navigation.getInstance.RightToLeft_PageNavigation(
                          context, HelpCenterScreen());
                    },
                  ),
                  settingtab(
                    heading: 'terms_conditions'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.termsAndConditions,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                  ),
                  settingtab(
                    heading: 'privacy_policy'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.privacyPolicy,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () => launchUrl(Uri.parse("https://toysell.hboxdigital.website/privacy_policy")),
                  ),
                  settingtab(
                    heading: 'delete_account'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.deleteAccount,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () => _showDeleteAccountConfirmation(context),
                  ),
                  settingtab(
                    heading: 'logout'.tr,
                    icon: ImageWidget(
                      imageUrl: AssetPaths.logout,
                      height: 21.sp,
                      width: 21.sp,
                    ),
                    onPress: () {
                      DataStroge.getInstance.logout();
                      Navigation.getInstance.pagePushAndReplaceNavigation(
                          context, AuthenticationScreen());
                      Get.clearRouteTree();
                    },
                  ),
                ],
              ),
            ),
          ));
    });
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    var themeHelper = Get.find<ThemeHelper>();
    PopupHelper.showPopup(
      context: context,
      title: "Delete Account",
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
      buttonText: "Delete",
      gradientColor: themeHelper.redColor,
      onButtonPressed: () {
        var controller = Get.put(LoginController());
        controller.deleteAccount().then((res) {
          if (res) {
            Navigation.getInstance.pagePushAndReplaceNavigation(
                context, AuthenticationScreen());
            Get.clearRouteTree();
          }
        });
      },
    );
  }
}

class settingtab extends StatelessWidget {
  const settingtab({
    super.key,
    required this.icon,
    required this.heading,
    this.onPress,
  });

  final Widget icon;
  final String heading;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return SpringWidget(
      onTap: onPress ?? () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1)
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  icon,
                  SizedBox(
                    width: 5.sp,
                  ),
                  Text(heading)
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black.withOpacity(0.3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
