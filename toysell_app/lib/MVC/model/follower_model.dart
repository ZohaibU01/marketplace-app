import 'package:toysell_app/MVC/model/userModel.dart';

class FollowerModel {
  final int id;
  final int followerId;
  final int followingId;
  final String createdAt;
  final String updatedAt;
  final UserModel follower;

  FollowerModel({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
    required this.updatedAt,
    required this.follower,
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'] ?? 0,
      followerId: json['follower_id'] ?? 0,
      followingId: json['following_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      follower: UserModel.fromJson(json['follower']),
    );
  }
}
