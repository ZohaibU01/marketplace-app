import 'dart:convert';

import 'package:shimmer/shimmer.dart';
import 'package:toysell_app/MVC/controller/productController.dart';
import 'package:toysell_app/MVC/model/chat_model.dart';
import 'package:toysell_app/MVC/view/commonScreens/productDetailScreen.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/asset_paths.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/data/mockData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:toysell_app/helper/internet_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api_service.dart';
import '../../../components/product_chat_card.dart';
import '../../controller/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.chatModel, required this.isBuyer});

  final ChatItem chatModel;

  final bool isBuyer;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final internetController = Get.put(InternetController());
  
  final messageController = TextEditingController();

  final ChatController chatController = Get.put(ChatController());

  bool isLoading = true;

  @override
  void initState() {
    chatController.fetchChatMessages(widget.chatModel.id).then(
          (value) => mounted
              ? setState(() {
                  isLoading = false;
                })
              : null,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return AnnotatedRegion(
        value: themecontroller.systemUiOverlayStyleForwhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.sp,
                    child: ClipOval(
                      child: ImageWidget(
                        boxfit: BoxFit.cover,
                        height: 50.sp,
                        width: 50.sp,
                        imageUrl: widget.chatModel.seller.profile ?? "",
                      ),
                    ),
                  ),
                  SizedBox(width: 5.sp),
                  Text(
                    widget.chatModel.seller.name,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Divider(
                  color: themecontroller.textcolor.withValues(alpha: 0.1),
                  height: 2,
                ),
                ProductChatCard(
                  imageUrl: widget.chatModel.item.image,
                  productName: widget.chatModel.item.name,
                  price: "\$${widget.chatModel.item.price}",
                  priceDetail: "incl 55",
                  item_id: widget.chatModel.itemId,
                  iconUrl: AssetPaths.verifiedIcon,
                ),
                Divider(
                  color: themecontroller.textcolor.withValues(alpha: 0.1),
                  height: 2,
                ),
                OfferBubble(chat: widget.chatModel, isBuyer: widget.isBuyer),
                Expanded(
                  child: Builder(builder: (_) {
                    if (isLoading) {
                      return _buildShimmerList();
                    }
                    return Obx(() => ListView.builder(
                          reverse: true,
                          itemCount: chatController.messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final message = chatController.messages[index];
                            return ChatBubble(
                              message: Message(
                                sender: message.senderId !=
                                        DataStroge.currentUser.value!.id
                                    ? "sender"
                                    : "receiver",
                                text: message.message,
                              ),
                            );
                          },
                        ));
                  }),
                ),
                // TextField for sending messages
                _buildMessageInput(themecontroller, widget.chatModel),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMessageInput(ThemeHelper themecontroller, ChatItem chat) {
    return Container(
      height: 50.sp,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: CustomTextFieldWidget(
              controller: messageController,
              hintText: 'enter_message'.tr,
              onsubmit: () {},
              borderRadius: 20,
              TextColor: themecontroller.greyColor,
              fieldColor: const Color.fromARGB(255, 244, 244, 245),
              inputType: TextInputType.multiline,
              label: 'Write your message here',
              enabled: true,
              suffixIcon: SizedBox(
                width: 70.sp,
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.black),
                    SizedBox(width: 15.sp),
                    const Icon(Icons.folder_copy, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 5.sp),
          SpringWidget(
            onTap: () async {
              final messageText = messageController.text.trim();
              if (messageText.isNotEmpty) {
                await chatController.sendMessage(
                  itemOfferId: chat.id,
                  message: messageText,
                );
                messageController.clear();
              } else {
                Get.snackbar('Error', 'message_empty_error'.tr);
              }
            },
            child: CircleAvatar(
              backgroundColor: themecontroller.colorPrimaryBlue,
              radius: 20.sp,
              child: Obx(
                () => Visibility(
                  visible: !chatController.isSending.value,
                  replacement: SizedBox(
                      height: 15.sp,
                      width: 15.sp,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                    color: Colors.white,
                    height: 15.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      reverse: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Align(
              alignment:
                  index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.sp),
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: index % 2 == 0
                      ? BorderRadius.only(
                          topLeft: Radius.circular(20.sp),
                          topRight: Radius.circular(20.sp),
                          bottomRight: Radius.circular(20.sp))
                      : BorderRadius.only(
                          topLeft: Radius.circular(20.sp),
                          topRight: Radius.circular(20.sp),
                          bottomLeft: Radius.circular(20.sp)),
                ),
                child: Container(
                  width: 200.sp, // Placeholder bubble width
                  height: 15.sp, // Placeholder bubble height
                  color: Colors.grey.shade300, // Placeholder color
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Align(
        alignment: message.sender == 'sender'
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: message.sender == 'sender'
                ? themecontroller.greyColor.withValues(alpha: 0.5)
                : themecontroller.colorPrimaryBlue,
            borderRadius: message.sender == 'sender'
                ? BorderRadius.only(
                    topLeft: Radius.circular(20.sp),
                    topRight: Radius.circular(20.sp),
                    bottomRight: Radius.circular(20.sp))
                : BorderRadius.only(
                    topLeft: Radius.circular(20.sp),
                    topRight: Radius.circular(20.sp),
                    bottomLeft: Radius.circular(20.sp)),
          ),
          child: Text(
            message.text,
            style: TextStyle(
                color: message.sender == 'sender'
                    ? themecontroller.textcolor
                    : themecontroller.bgcolor),
          ),
        ),
      );
    });
  }
}

class OfferBubble extends StatelessWidget {
  final ChatItem chat;
  final bool isBuyer;

  const OfferBubble({super.key, required this.chat, required this.isBuyer});

  Future<void> _manageOffer(int offerId, int status) async {
    try {
      final response = await ApiService.post(
        'manage-offer',
        data: {
          'offer_id': offerId.toString(),
          'status': status.toString(), // 1 for accept, 0 for reject
        },
        token: DataStroge.accesstoken.value,
      );

      final result = jsonDecode(response.body);
      if (result['error'] == false) {
        Get.snackbar("Success", result['message'] ?? "Offer updated");
      } else {
        Get.snackbar("Error", result['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update offer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeHelper>(builder: (themecontroller) {
      return Align(
        alignment: !isBuyer ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themecontroller.colorPrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.sp),
              bottomRight: Radius.circular(10.sp),
              bottomLeft: Radius.circular(10.sp),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${"offer_text".tr} \$${chat.amount}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themecontroller.bgcolor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isBuyer) ...[
                SizedBox(height: 8.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _manageOffer(chat.id, 1),
                      child: const Text("Accept"),
                    ),
                    SizedBox(width: 10.sp),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _manageOffer(chat.id, 0),
                      child: const Text("Reject"),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      );
    });
  }
}
