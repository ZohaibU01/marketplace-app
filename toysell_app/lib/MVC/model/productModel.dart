import 'categoryModel.dart';

class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final String imageUrl; // Single main image
  final List<String> images; // Additional images
  final String address;
  final double latitude;
  final double longitude;
  final bool isPremium;
  final String contact;
  final String country;
  final String state;
  final String city;
  final String status;
  final String? rejectedReason;
  final String? videoLink;
  final int? areaId;
  final int userId;
  final int? soldTo;
  final int categoryId;
  final String? allCategoryIds;
  final String? expiryDate;
  final int clicks;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isFeature;
  final int totalLikes;
  final bool isLiked;
  final bool isAlreadyOffered;
  final bool isAlreadyReported;
  final int isPurchased;
  final int likeCount; // New field

  // User fields
  final String sellerName;
  final String? sellerPicture;

  // Category fields
  final CategoryModel? category;

  final List<ItemOffer> itemOffers;


  // Constructor
  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.images,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isPremium,
    required this.contact,
    required this.country,
    required this.state,
    required this.city,
    required this.status,
    this.rejectedReason,
    this.videoLink,
    this.areaId,
    required this.userId,
    this.soldTo,
    required this.categoryId,
    this.allCategoryIds,
    this.expiryDate,
    required this.clicks,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isFeature,
    required this.totalLikes,
    required this.isLiked,
    required this.isAlreadyOffered,
    required this.isAlreadyReported,
    required this.isPurchased,
    required this.likeCount, // Initialize new field
    required this.sellerName,
    this.sellerPicture,
    required this.category,
    required this.itemOffers,
  });

  // Factory constructor to create a Product from a Map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Calculate likeCount from the length of the favourites list
    int likeCount = (json['favourites'] as List?)?.length ?? 0;

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image'] ?? '',
      images: List<String>.from(json['gallery_images'] != null && (json['gallery_images'] as List).isNotEmpty ? (json['gallery_images'] as List<dynamic>).map((m) => m["image"] as String,).toList():[json['image'] ?? '']),
      address: json['address'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      isPremium: json['show_only_to_premium'] == 1,
      contact: json['contact'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      status: json['status'] ?? '',
      rejectedReason: json['rejected_reason'],
      videoLink: json['video_link'],
      areaId: json['area_id'],
      userId: json['user_id'] ?? 0,
      soldTo: json['sold_to'],
      categoryId: json['category_id'] ?? 0,
      allCategoryIds: json['all_category_ids'],
      expiryDate: json['expiry_date'],
      clicks: json['clicks'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      isFeature: json['is_feature'] ?? false,
      totalLikes: json['total_likes'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isAlreadyOffered: json['is_already_offered'] ?? false,
      isAlreadyReported: json['is_already_reported'] ?? false,
      isPurchased: json['is_purchased'] ?? 0,
      likeCount: likeCount, // Set calculated likeCount
      sellerName: json['user']?['name'] ?? 'Unknown Seller',
      sellerPicture: json['user']?['profile'],
      category: json['category'] == null ? null : CategoryModel.fromJson(json['category']),
      itemOffers: (json['item_offers'] as List<dynamic>?)
          ?.map((e) => ItemOffer.fromJson(e))
          .toList() ??
          [],
    );
  }

  // Convert the Product to a Map (useful for posting data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price.toString(),
      'image': imageUrl,
      'gallery_images': images,
      'address': address,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'show_only_to_premium': isPremium ? 1 : 0,
      'contact': contact,
      'country': country,
      'state': state,
      'city': city,
      'status': status,
      'rejected_reason': rejectedReason,
      'video_link': videoLink,
      'area_id': areaId,
      'user_id': userId,
      'sold_to': soldTo,
      'category_id': categoryId,
      'all_category_ids': allCategoryIds,
      'expiry_date': expiryDate,
      'clicks': clicks,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'is_feature': isFeature,
      'total_likes': totalLikes,
      'is_liked': isLiked,
      'is_already_offered': isAlreadyOffered,
      'is_already_reported': isAlreadyReported,
      'is_purchased': isPurchased,
      'user': {
        'name': sellerName,
        'profile': sellerPicture,
      },
      'category': category?.toJson(),
      'item_offers': itemOffers.map((e) => {
        'id': e.id,
        'seller_id': e.sellerId,
        'buyer_id': e.buyerId,
        'item_id': e.itemId,
        'status': e.status,
        'amount': e.amount,
        'created_at': e.createdAt,
        'updated_at': e.updatedAt,
      }).toList(),
    };
  }

  // CopyWith Method
  ProductModel copyWith({
    String? name,
    String? slug,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? images,
    String? address,
    double? latitude,
    double? longitude,
    bool? isPremium,
    String? contact,
    String? country,
    String? state,
    String? city,
    String? status,
    String? rejectedReason,
    String? videoLink,
    int? areaId,
    int? userId,
    int? soldTo,
    int? categoryId,
    String? allCategoryIds,
    String? expiryDate,
    int? clicks,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    bool? isFeature,
    int? totalLikes,
    bool? isLiked,
    bool? isAlreadyOffered,
    bool? isAlreadyReported,
    int? isPurchased,
    String? sellerName,
    String? sellerPicture,
    CategoryModel? category,
    int? likeCount,
    List<ItemOffer>? itemOffers
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPremium: isPremium ?? this.isPremium,
      contact: contact ?? this.contact,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      status: status ?? this.status,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      videoLink: videoLink ?? this.videoLink,
      areaId: areaId ?? this.areaId,
      userId: userId ?? this.userId,
      soldTo: soldTo ?? this.soldTo,
      categoryId: categoryId ?? this.categoryId,
      allCategoryIds: allCategoryIds ?? this.allCategoryIds,
      expiryDate: expiryDate ?? this.expiryDate,
      clicks: clicks ?? this.clicks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isFeature: isFeature ?? this.isFeature,
      totalLikes: totalLikes ?? this.totalLikes,
      isLiked: isLiked ?? this.isLiked,
      isAlreadyOffered: isAlreadyOffered ?? this.isAlreadyOffered,
      isAlreadyReported: isAlreadyReported ?? this.isAlreadyReported,
      isPurchased: isPurchased ?? this.isPurchased,
      sellerName: sellerName ?? this.sellerName,
      sellerPicture: sellerPicture ?? this.sellerPicture,
      category: category ?? this.category,
      likeCount: likeCount ?? this.likeCount,
      itemOffers: itemOffers ?? this.itemOffers,
    );
  }
}

class ItemOffer {
  final int id;
  final int sellerId;
  final int buyerId;
  final int itemId;
  final int status;
  final double amount;
  final String createdAt;
  final String updatedAt;

  ItemOffer({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.itemId,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemOffer.fromJson(Map<String, dynamic> json) {
    return ItemOffer(
      id: json['id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      buyerId: json['buyer_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      status: json['status'] ?? 0,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
