import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/view/Profile/profileSettingScreen.dart';
import 'package:toysell_app/MVC/view/commonScreens/chatScreen.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/helper/getx_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../constant/asset_paths.dart';
import '../../../helper/internet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controller/chat_controller.dart';
import '../../model/chat_model.dart'; // Add this for svg icons

class ConversationScreen extends StatelessWidget {
  ConversationScreen({super.key});

  final ChatController chatController = Get.put(ChatController())..onInit();
  final FocusNode _searchFocusNode = FocusNode();
  RxBool showbox = false.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Scaffold(
        backgroundColor: themecontroller.backgoundcolor,
        resizeToAvoidBottomInset: true,
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              SizedBox(height: 50.sp),
              Padding(
                padding: const EdgeInsets.all(Constants.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search and Profile
                    _buildHeader(themecontroller),
                    SizedBox(height: 10.sp),
                    // TabBar
                    TabBar(
                      indicatorColor: themecontroller.colorPrimary,
                      onTap: (value) {
                        chatController.selectedIndex = value;
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            'buying'.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'selling'.tr,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Buying Chats
                    Obx(() {
                      if (chatController.isLoading.value) {
                        return _buildShimmerList();
                      }
                      final filteredChats = chatController.buyerChats
                          .where((chat) => chat.seller.name
                              .toLowerCase()
                              .contains(chatController.searchQuery.value
                                  .toLowerCase()))
                          .toList();
                      if (filteredChats.isEmpty) {
                        return Center(
                          child: Text(
                            'no_chats_available'.tr,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          final chat = filteredChats[index];
                          return chatCard(chat: chat);
                        },
                      );
                    }),
                    // Selling Chats
                    Obx(() {
                      if (chatController.isLoading.value) {
                        return _buildShimmerList();
                      }
                      final filteredChats = chatController.sellerChats
                          .where((chat) => chat.seller.name
                              .toLowerCase()
                              .contains(chatController.searchQuery.value
                                  .toLowerCase()))
                          .toList();
                      if (filteredChats.isEmpty) {
                        return Center(
                          child: Text(
                            'no_chats_available'.tr,
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.sp),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          final chat = filteredChats[index];
                          return chatCard(chat: chat);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(ThemeHelper themecontroller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'chats'.tr,
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        ),
        ..._buildSearchBar(themecontroller),
      ],
    );
  }

  List<Widget> _buildSearchBar(ThemeHelper themecontroller) {
    return [
      Obx(
        () => Visibility(
          visible: showbox.value,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: showbox.value ? 1.0 : 0.0,
            child: SizedBox(
              width: 270.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 190.sp,
                    child: CustomTextFieldWidget(
                      enabled: true,
                      label: 'search'.tr,
                      controller: TextEditingController(),
                      hintText: "",
                      inputType: TextInputType.name,
                      icon: Icon(
                        Icons.search,
                        size: 20.sp,
                        color: themecontroller.colorPrimary,
                      ),
                      onchange: (value) {
                        chatController.searchQuery.value = value;
                      },
                      focusNode: _searchFocusNode,
                      onsubmit: () {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your start point';
                        }
                        return null;
                      },
                    ),
                  ),
                  SpringWidget(
                    onTap: () {
                      chatController.searchQuery.value = '';
                      showbox.value = !showbox.value;
                    },
                    child: CircleAvatar(
                      radius: 20.sp,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      child: SvgPicture.asset(
                        "assets/icons/cross.svg",
                        height: 17.sp,
                        width: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Obx(
        () => SpringWidget(
          onTap: () {
            showbox.value = !showbox.value;
          },
          child: Visibility(
            visible: !showbox.value,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: !showbox.value ? 1.0 : 0.0,
              child: CircleAvatar(
                radius: 20.sp,
                backgroundColor: Colors.grey.withOpacity(0.2),
                child: SvgPicture.asset(
                  AssetPaths.searchBarIconSVG,
                  height: 17.sp,
                  width: 17.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 16.sp),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                CircleAvatar(
                    radius: 25.sp, backgroundColor: Colors.grey.shade300),
                SizedBox(width: 10.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10.sp,
                        width: 150.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 5.sp),
                      Container(
                        height: 10.sp,
                        width: 100.sp,
                        color: Colors.grey.shade300,
                      ),
                    ],
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

class chatCard extends StatelessWidget {
  final ChatItem chat;
  final ChatController chatController = Get.find<ChatController>();

  chatCard({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Container(
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
        ),
        child: SpringWidget(
          onTap: () {
            Navigation.getInstance.RightToLeft_PageNavigation(
                context,
                ChatScreen(
                  chatModel: chat,
                  isBuyer: chatController.selectedIndex == 0,
                ));
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.sp,
                backgroundImage: NetworkImage(chat.seller.profile ?? ''),
              ),
              SizedBox(width: 10.sp),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.seller.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(chat.item.name, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
