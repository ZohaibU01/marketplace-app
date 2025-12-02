import 'productModel.dart';

class UserModel {
  int id;
  String name;
  String email;
  String? mobile;
  String? emailVerifiedAt;
  String? profile;
  String type;
  String fcmId;
  int notification;
  String firebaseId;
  String? address;
  String createdAt;
  String updatedAt;
  String? deletedAt;
  String? countryCode;
  int showPersonalDetails;
  int isVerified;
  String? stripeAccountId;
  String? onboardLink;
  double? averageRating;
  List<dynamic> ratings;
  List<dynamic> sellerReviews;
  List<dynamic> userReports;
  List<dynamic> fcmTokens;
  List<ProductModel> items; // Reusing ProductModel for items

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.emailVerifiedAt,
    this.profile,
    required this.type,
    required this.fcmId,
    required this.notification,
    required this.firebaseId,
    this.address,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.countryCode,
    required this.showPersonalDetails,
    required this.isVerified,
    this.stripeAccountId,
    this.onboardLink,
    this.averageRating,
    this.ratings = const [],
    this.sellerReviews = const [],
    this.userReports = const [],
    this.fcmTokens = const [],
    this.items = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Test User',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      emailVerifiedAt: json['email_verified_at'],
      profile: json['profile'],
      type: json['type'] ?? '',
      fcmId: json['fcm_id'] ?? '',
      notification: json['notification'] ?? 0,
      firebaseId: json['firebase_id'] ?? '',
      address: json['address'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      countryCode: json['country_code'],
      showPersonalDetails: json['show_personal_details'] ?? 0,
      isVerified: json['is_verified'] ?? 0,
      stripeAccountId: json['stripe_acc_id'],
      onboardLink: json['onboard_link'],
      averageRating: json['average_rating'] != null
          ? double.tryParse(json['average_rating'].toString())
          : null,
      ratings: json['ratings'] ?? [],
      sellerReviews: json['seller_review'] ?? [],
      userReports: json['user_reports'] ?? [],
      fcmTokens: json['fcm_tokens'] ?? [],
      items: (json['items'] as List? ?? [])
          .map((item) => ProductModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'email_verified_at': emailVerifiedAt,
      'profile': profile,
      'type': type,
      'fcm_id': fcmId,
      'notification': notification,
      'firebase_id': firebaseId,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'country_code': countryCode,
      'show_personal_details': showPersonalDetails,
      'is_verified': isVerified,
      'stripe_acc_id': stripeAccountId,
      'onboard_link': onboardLink,
      'average_rating': averageRating,
      'ratings': ratings,
      'seller_review': sellerReviews,
      'user_reports': userReports,
      'fcm_tokens': fcmTokens,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Role {
  int id;
  String name;
  String guardName;
  int customRole;
  String createdAt;
  String updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.customRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      guardName: json['guard_name'] ?? '',
      customRole: json['custom_role'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
      'custom_role': customRole,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
