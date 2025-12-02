import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:toysell_app/MVC/controller/SellsController.dart';
import 'package:toysell_app/MVC/model/categoryModel.dart';
import 'package:toysell_app/MVC/model/productModel.dart';
import 'package:toysell_app/MVC/view/Profile/boostingScreen.dart';
import 'package:toysell_app/components/custom_textfiled.dart';
import 'package:toysell_app/components/image_widget.dart';
import 'package:toysell_app/components/round_button.dart';
import 'package:toysell_app/constant/constants.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/helper/data_storage.dart';

import '../../../components/spring_widget.dart';
import '../../../helper/getx_helper.dart';

class SellFormscreen extends StatefulWidget {
  SellFormscreen({
    super.key,
    required this.categoryModel,
    this.productData,
  });

  final CategoryModel categoryModel;
  final ProductModel? productData;

  @override
  State<SellFormscreen> createState() => _SellFormscreenState();
}

class _SellFormscreenState extends State<SellFormscreen> {
  final sellsController = Get.put(SellsController());

  @override
  Widget build(BuildContext context) {
    // Initialize fields with product data if provided
    if (widget.productData != null) {
      sellsController.titleController.text = widget.productData!.name;
      sellsController.descriptionController.text = widget.productData!.description;
      sellsController.priceController.text = widget.productData!.price.toString();
      sellsController.selectedSubCategory.value = widget.categoryModel.subcategories
          ?.firstWhereOrNull((subcategory) => subcategory.id == widget.productData!.category?.id) ??
          widget.categoryModel;
      sellsController.images.value = widget.productData!.images;
    }

    return GetBuilder<ThemeHelper>(builder: (themeController) {
      return AnnotatedRegion(
        value: themeController.systemUiOverlayStyleForwhite,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: themeController.backgoundcolor,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              surfaceTintColor: themeController.backgoundcolor,
              backgroundColor: themeController.backgoundcolor,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              title: Text(
                widget.productData != null ? 'edit_product'.tr : 'add_product'.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.sp,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Constants.screenPadding,
                vertical: Constants.screenPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productData != null ? 'update_details'.tr : 'almost_there'.tr,
                      style: TextStyle(color: Colors.black, fontSize: 20.sp),
                    ),
                    Text(
                      widget.categoryModel.name,
                      style: TextStyle(
                        color: themeController.colorPrimary,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    _buildLabel('title_label'.tr),
                    CustomTextFieldWidget(
                      controller: sellsController.titleController,
                      hintText: 'title_hint'.tr,
                      onsubmit: () {},
                      inputType: TextInputType.text,
                      label: '',
                      enabled: true,
                    ),
                    SizedBox(height: 10.sp),
                    _buildLabel('subcategory_label'.tr),
                    Obx(
                          () => DropdownButtonFormField<CategoryModel>(
                        value: sellsController.selectedSubCategory.value,
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        onChanged: (value) {
                          sellsController.selectedSubCategory.value = value!;
                        },
                        items: widget.categoryModel.subcategories?.map((subcategory) {
                          return DropdownMenuItem<CategoryModel>(
                            value: subcategory,
                            child: Text(subcategory.name,style:TextStyle(fontSize: 10.sp),),
                          );
                        }).toList(),
                        hint: Text(
                          'select_subcategory'.tr,
                          style: TextStyle(
                              color: themeController.textcolor.withOpacity(0.5), fontSize: 11),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                            borderSide: BorderSide(
                              color: themeController.colorPrimary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    _buildLabel('description_label'.tr),
                    CustomTextFieldWidget(
                      controller: sellsController.descriptionController,
                      hintText: 'description_hint'.tr,
                      maxLines: 10,
                      onsubmit: () {},
                      inputType: TextInputType.text,
                      label: '',
                      enabled: true,
                    ),
                    SizedBox(height: 10.sp),
                    Obx(
                          () => sellsController.images.isEmpty
                          ? Row(
                        children: [
                          Expanded(
                            child: SpringWidget(
                              onTap: () async {
                                final controllersProvider =
                                Get.put<GetxControllersProvider>(GetxControllersProvider());
                                var newImage = await controllersProvider.getImage();
                                if(newImage !=null){
                                  sellsController.images
                                      .add((newImage));
                                }

                              },
                              child: Container(
                                height: 120.sp,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10.sp)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/gallery.svg",
                                      height: 35.sp,
                                      width: 35.sp,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    Text(
                                      'gallery',
                                      style: TextStyle(fontSize: 10.sp),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Expanded(
                            child: SpringWidget(
                              onTap: () async {
                                final controllersProvider =
                                Get.put<GetxControllersProvider>(GetxControllersProvider());
                                var newImage = await controllersProvider.getFromCameraImage();
                                if(newImage !=null){
                                  sellsController.images
                                      .add((newImage));
                                }
                              },
                              child: Container(
                                height: 120.sp,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10.sp)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Camera.svg",
                                      height: 35.sp,
                                      width: 35.sp,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    Text(
                                      'Camera',
                                      style: TextStyle(fontSize: 10.sp),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                          : SizedBox(
                        height: 100.sp,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sellsController.images.length,
                          itemBuilder: (context, index) {
                            final image = sellsController.images[index];
                            if(sellsController.images.length == index + 1){
                              return Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.sp),
                                          child: widget.productData == null ? Image.file(
                                            File(image),
                                            height: 150.sp,
                                            width: 150.sp,
                                            fit: BoxFit.cover,
                                          ) : ImageWidget(imageUrl: image),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              sellsController.removeImage(image);
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 20.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SpringWidget(
                                            onTap: () async {
                                              final controllersProvider =
                                              Get.put<GetxControllersProvider>(GetxControllersProvider());
                                              var newImage = await controllersProvider.getImage();
                                              if(newImage !=null){
                                                sellsController.images
                                                    .add((newImage));
                                              }

                                            },
                                            child: Container(
                                              height: 120.sp,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black.withOpacity(0.5)),
                                                  borderRadius: BorderRadius.circular(10.sp)),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/gallery.svg",
                                                    height: 35.sp,
                                                    width: 35.sp,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    height: 10.sp,
                                                  ),
                                                  Text(
                                                    'gallery',
                                                    style: TextStyle(fontSize: 10.sp),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.sp,
                                        ),
                                        Expanded(
                                          child: SpringWidget(
                                            onTap: () async {
                                              final controllersProvider =
                                              Get.put<GetxControllersProvider>(GetxControllersProvider());
                                              var newImage = await controllersProvider.getFromCameraImage();
                                              if(newImage !=null){
                                                sellsController.images
                                                    .add((newImage));
                                              }
                                            },
                                            child: Container(
                                              height: 120.sp,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black.withOpacity(0.5)),
                                                  borderRadius: BorderRadius.circular(10.sp)),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/Camera.svg",
                                                    height: 35.sp,
                                                    width: 35.sp,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    height: 10.sp,
                                                  ),
                                                  Text(
                                                    'Camera',
                                                    style: TextStyle(fontSize: 10.sp),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.sp),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    child: !image.startsWith("http") ? Image.file(
                                      File(image),
                                      height: 150.sp,
                                      width: 150.sp,
                                      fit: BoxFit.cover,
                                    ) : ImageWidget(imageUrl: image),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {
                                        sellsController.removeImage(image);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    _buildLabel('price_label'.tr),
                    CustomTextFieldWidget(
                      controller: sellsController.priceController,
                      hintText: 'price_hint'.tr,
                      inputType: TextInputType.number,
                      onsubmit: () {},
                      label: '',
                      enabled: true,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Obx(
                  () => RoundButton(
                height: 50.sp,
                gradient: true,
                borderRadius: 20.sp,
                title: sellsController.isLoading.value
                    ? ''
                    : (widget.productData != null ? 'update_now'.tr : 'post_now'.tr),
                loading: sellsController.isLoading.value,
                onTap: () {
                  if (widget.productData != null) {
                    // Update the productData model with new values from the form
                    final updatedProduct = widget.productData!.copyWith(
                      name: sellsController.titleController.text.trim(),
                      description: sellsController.descriptionController.text.trim(),
                      price: double.tryParse(sellsController.priceController.text.trim()) ?? widget.productData!.price,
                      images: sellsController.images, // Update with the current images
                      category: sellsController.selectedSubCategory.value ?? widget.productData!.category,
                    );

                    sellsController.updateProduct(updatedProduct).then((value) {
                      if(value){
                        sellsController.resetForm();
                        Navigator.pop(context,value);
                      }

                    });
                  }
                  else {
                    sellsController.postProduct(
                      address: "Shahrah-e-Faisal",
                      contact: "03021546788",
                      latitude: 24.8607,
                      longitude: 67.0011,
                      country: "Pakistan",
                      state: "Sindh",
                      city: "Karachi",
                      slug: "product-slug",
                      token: DataStroge.accesstoken.value,
                      context: context,
                    ).then((product) {
                      if (product != null) {
                        Navigation.getInstance.bottomToTop_PageNavigation(context, BoostingScreen(product: product,));
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }

  @override
  void dispose() {
    sellsController.resetForm();
    super.dispose();
  }
}
