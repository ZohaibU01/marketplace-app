import 'package:toysell_app/MVC/model/productModel.dart';

class Transaction {
  final int id;
  final double price;
  final double finalPrice;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Buyer buyer;
  final ProductModel item;
  final Payment payment;

  Transaction({
    required this.id,
    required this.price,
    required this.finalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.buyer,
    required this.item,
    required this.payment,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      buyer: Buyer.fromJson(json['buyer']),
      item: ProductModel.fromJson(json['item']), // Use ProductModel
      payment: Payment.fromJson(json['payment']),
    );
  }
}

class Buyer {
  final int id;
  final String name;
  final String email;

  Buyer({required this.id, required this.name, required this.email});

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class Payment {
  final int id;
  final String transactionId;
  final double amount;
  final String currency;
  final String receiptUrl;
  final String lastFour; // Added last_four field

  Payment({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.receiptUrl,
    required this.lastFour,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      transactionId: json['transaction_id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currency: json['currency'],
      receiptUrl: json['receipt_url'],
      lastFour: json['last_four'] ?? '', // Parse last_four field
    );
  }
}
