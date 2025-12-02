import 'order_model.dart';
import 'productModel.dart';

class MyShopOrderModel {
  final int id;
  final int buyerId;
  final int sellerId;
  final int itemId;
  final int paymentId;
  final double price;
  final double finalPrice;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  // Nested models
  final Buyer buyer;
  final ProductModel item;
  final Payment payment;
  final BillingAddress billingAddress;
  final ShippingAddress shippingAddress;

  final String? pickupBookingId;
  final String? trackingId;
  final String? trackingUrl;

  MyShopOrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.itemId,
    required this.paymentId,
    required this.price,
    required this.finalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.buyer,
    required this.item,
    required this.payment,
    required this.billingAddress,
    required this.shippingAddress,

    this.pickupBookingId,
    this.trackingId,
    this.trackingUrl,
  });

  factory MyShopOrderModel.fromJson(Map<String, dynamic> json) {
    return MyShopOrderModel(
      id: json['id'] ?? 0,
      buyerId: json['buyer_id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      paymentId: json['payment_id'] ?? 0,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      finalPrice: double.tryParse(json['final_price'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      buyer: Buyer.fromJson(json['buyer']),
      item: ProductModel.fromJson(json['item']),
      payment: Payment.fromJson(json['payment']),
      billingAddress: BillingAddress.fromJson(json['billing_address'] ?? {}),
      shippingAddress: ShippingAddress.fromJson(json['shipping_address'] ?? {}),

      pickupBookingId: json['pickup_booking_id'],
      trackingId: json['tracking_id'],
      trackingUrl: json['tracking_url'],
    );
  }
}

class Buyer {
  final int id;
  final String name;
  final String email;
  final String? mobile;
  final String? profile;
  final String type;

  Buyer({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.profile,
    required this.type,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      profile: json['profile'],
      type: json['type'] ?? '',
    );
  }
}
