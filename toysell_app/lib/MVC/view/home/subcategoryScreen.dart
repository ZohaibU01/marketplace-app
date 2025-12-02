import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toysell_app/components/spring_widget.dart';
import 'package:toysell_app/constant/navigation.dart';
import 'package:toysell_app/constant/theme.dart';
import 'package:toysell_app/MVC/model/categoryModel.dart';
import 'product_listing_screen.dart';

class SubProductCategoryScreen extends StatelessWidget {
  final String title;
  final List<CategoryModel> subCategories;
  final int parentCategoryId;

  final themeHelper = Get.find<ThemeHelper>();

  SubProductCategoryScreen({
    super.key,
    required this.title,
    required this.subCategories,
    required this.parentCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: themeHelper.colorIcon),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: TextStyle(
            color: themeHelper.textcolor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpringWidget(
            onTap: () {
              Navigation.getInstance.RightToLeft_PageNavigation(
                context,
                ProductListingScreen(
                  categoryId: parentCategoryId,
                  title: title,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'subcategory_title'.trParams({'title': title}),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: ListTile(
                        title: Text(
                          subCategory.name,
                          style: TextStyle(
                            color: themeHelper.textcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {
                          Navigation.getInstance.RightToLeft_PageNavigation(
                            context,
                            ProductListingScreen(
                              categoryId: subCategory.id,
                              title: subCategory.name,
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
