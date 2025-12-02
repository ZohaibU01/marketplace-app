import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/api_service.dart';
import 'package:toysell_app/helper/data_storage.dart';
import 'package:toysell_app/helper/snack_bar_helper.dart';

import '../../../components/image_widget.dart';
import '../../controller/user_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserController userController = Get.find<UserController>();
  final theme = Get.find<ThemeHelper>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressController;
  late TextEditingController countryCodeController;

  File? profileImage;
  bool showPersonalDetails = false;

  final countryPicker = const FlCountryCodePicker();
  CountryCode? selectedCountryCode;

  @override
  void initState() {
    final user = userController.user.value;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    mobileController = TextEditingController(text: user.mobile);
    addressController = TextEditingController(text: user.address ?? "");
    countryCodeController = TextEditingController(text: user.countryCode ?? "");
    selectedCountryCode = CountryCode(name: '', code: '', dialCode: '+${user.countryCode ?? ""}');
    showPersonalDetails = user.showPersonalDetails == 1;
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final extension = picked.path.split('.').last.toLowerCase();
      final sizeInKB = await file.length() ~/ 1024;

      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        SnackbarHelper.showError("Invalid file", "Only JPG, JPEG, and PNG images are allowed.");
        return;
      }

      if (sizeInKB > 4096) {
        SnackbarHelper.showError("File too large", "Please select an image less than 4MB.");
        return;
      }

      setState(() {
        profileImage = file;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.bgcolor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: theme.bgcolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 100.sp,
                        width: 100.sp,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorPrimary,
                            width: 3.sp,
                          ),
                        ),
                        child: ClipOval(
                          child: profileImage != null
                              ? Image.file(
                            profileImage!,
                            fit: BoxFit.cover,
                          )
                              : ImageWidget(
                            imageUrl: userController.user.value.profile ?? 'asdasd',
                            height: 100.sp,
                            width: 100.sp,
                            boxfit: BoxFit.cover,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 15.sp,
                        backgroundColor: theme.colorPrimary,
                        child: const Icon(Icons.edit, size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.sp),
              _buildTextField(nameController, 'Full Name'),
              SizedBox(height: 12.sp),
              _buildTextField(emailController, 'Email', keyboardType: TextInputType.emailAddress,enableField: false),
              SizedBox(height: 12.sp),
              _buildTextField(mobileController, 'Mobile'),
              SizedBox(height: 12.sp),
              _buildTextField(addressController, 'Address'),
              SizedBox(height: 12.sp),
              // GestureDetector(
              //   onTap: () async {
              //     final code = await countryPicker.showPicker(context: context);
              //     if (code != null) {
              //       setState(() {
              //         selectedCountryCode = code;
              //         countryCodeController.text = code.dialCode.replaceAll('+', '');
              //       });
              //     }
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(12.sp),
              //       border: Border.all(color: Colors.grey.shade300),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           selectedCountryCode?.dialCode ?? "+Select",
              //           style: TextStyle(
              //             fontSize: 14.sp,
              //             fontFamily: "Poppins",
              //             color: selectedCountryCode == null ? Colors.grey : Colors.black,
              //           ),
              //         ),
              //         const Icon(Icons.arrow_drop_down),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 12.sp),
              SwitchListTile(
                title: const Text("Show Personal Details"),
                value: showPersonalDetails,
                onChanged: (value) {
                  setState(() => showPersonalDetails = value);
                },
              ),
              SizedBox(height: 20.sp),
              Obx(
                ()=>RoundButton(
                  title: "Update",
                  gradient: true,
                  loading: userController.isLoading.value,
                  onTap: () async{
                    await userController.updateProfile(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      mobile: mobileController.text.trim(),
                      address: addressController.text.trim(),
                      countryCode: countryCodeController.text.trim(),
                      showPersonalDetails: showPersonalDetails,
                      profileImage: profileImage, // can be null
                    );
                  },
                  height: 42.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text,bool enableField = true}) {
    return TextFormField(
      controller: controller,
      validator: (val) => val == null || val.isEmpty ? '$hint is required' : null,
      keyboardType: keyboardType,
      enabled: enableField,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
