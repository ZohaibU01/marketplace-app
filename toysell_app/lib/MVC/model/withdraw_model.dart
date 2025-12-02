import 'package:toysell_app/MVC/model/userModel.dart';

class WithdrawModel {
  final int id;
  final int userId;
  final String requestedAmount;
  final String transferredAmount;
  final String platformFee;
  final String currency;
  final String stripeTransferId;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final UserModel user;

  WithdrawModel({
    required this.id,
    required this.userId,
    required this.requestedAmount,
    required this.transferredAmount,
    required this.platformFee,
    required this.currency,
    required this.stripeTransferId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      requestedAmount: json['requested_amount'] ?? '0.00',
      transferredAmount: json['transferred_amount'] ?? '0.00',
      platformFee: json['platform_fee'] ?? '0.00',
      currency: json['currency'] ?? '',
      stripeTransferId: json['stripe_transfer_id'] ?? '',
      notes: json['notes'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

