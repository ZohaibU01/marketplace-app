
class CategoryModel {
  final int id;
  final String name;
  final String? icon;
  final String? description;
  final int? parentCategoryId;
  final String? slug;
  final int? status;
  final List<CategoryModel>? subcategories;

  // Constructor
  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    this.parentCategoryId,
    this.slug,
    required this.status,
    this.subcategories,
  });

  // Convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'parent_category_id': parentCategoryId,
      'slug': slug,
      'status': status,
      'subcategories': subcategories?.map((subcategory) => subcategory.toJson()).toList(),
    };
  }

  // Factory constructor to create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['image'],
      description: json['description'],
      parentCategoryId: json['parent_category_id'],
      slug: json['slug'],
      status: json['status'],
      subcategories: (json['subcategories'] as List?)
          ?.map((subcategory) => CategoryModel.fromJson(subcategory))
          .toList(),
    );
  }
}

