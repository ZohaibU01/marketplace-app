import 'my_shop_order_model.dart';
import 'productModel.dart';

class MyOrderModel {
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

  // Nested models for seller, item, and payment
  final Seller seller;
  final ProductModel item;
  final Payment payment;
  final BillingAddress billingAddress;
  final ShippingAddress shippingAddress;

  final String? pickupBookingId;
  final String? trackingId;
  final String? trackingUrl;

  MyOrderModel({
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
    required this.seller,
    required this.item,
    required this.payment,
    required this.billingAddress,
    required this.shippingAddress,

    this.pickupBookingId,
    this.trackingId,
    this.trackingUrl,
  });

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
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
      seller: Seller.fromJson(json['seller']),
      item: ProductModel.fromJson(json['item']),
      payment: Payment.fromJson(json['payment']),
      billingAddress: BillingAddress.fromJson(json['billing_address'] ?? {}),
      shippingAddress: ShippingAddress.fromJson(json['shipping_address'] ?? {}),

      pickupBookingId: json['pickup_booking_id'],
      trackingId: json['tracking_id'],
      trackingUrl: json['tracking_url'],
    );
  }

  factory MyOrderModel.fromMyShopOrderModel(MyShopOrderModel shopOrder) {
    return MyOrderModel(
      id: shopOrder.id,
      buyerId: shopOrder.buyerId,
      sellerId: shopOrder.sellerId,
      itemId: shopOrder.itemId,
      paymentId: shopOrder.paymentId,
      price: shopOrder.price,
      finalPrice: shopOrder.finalPrice,
      status: shopOrder.status,
      createdAt: shopOrder.createdAt,
      updatedAt: shopOrder.updatedAt,
      deletedAt: shopOrder.deletedAt,
      seller: Seller(
        id: shopOrder.buyer.id,
        name: shopOrder.buyer.name,
        email: shopOrder.buyer.email,
        mobile: shopOrder.buyer.mobile,
        profile: shopOrder.buyer.profile,
        type: shopOrder.buyer.type,
      ),
      item: shopOrder.item,
      payment: shopOrder.payment,
      billingAddress: BillingAddress(
        name: shopOrder.billingAddress.name,
        phone: shopOrder.billingAddress.phone,
        billingAddress: shopOrder.billingAddress.billingAddress,
      ),
      shippingAddress: ShippingAddress(
        name: shopOrder.shippingAddress.name,
        phone: shopOrder.shippingAddress.phone,
        shippingAddress: shopOrder.shippingAddress.shippingAddress ?? '',
      ),

      pickupBookingId: shopOrder.pickupBookingId,
      trackingId: shopOrder.trackingId,
      trackingUrl: shopOrder.trackingUrl,
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String email;
  final String? mobile;
  final String? profile;
  final String type;

  Seller({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.profile,
    required this.type,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      profile: json['profile'],
      type: json['type'] ?? '',
    );
  }
}

class Payment {
  final int id;
  final String transactionId;
  final String lastFour;
  final String customerId;
  final double amount;
  final String currency;
  final String? receiptUrl;
  final String status;
  final String brand;

  Payment({
    required this.id,
    required this.transactionId,
    required this.lastFour,
    required this.customerId,
    required this.amount,
    required this.currency,
    this.receiptUrl,
    required this.status,
    required this.brand,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      transactionId: json['transaction_id'] ?? '',
      lastFour: json['last_four'] ?? '',
      customerId: json['customer_id'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currency: json['currency'] ?? '',
      receiptUrl: json['receipt_url'],
      status: json['status'] ?? '',
      brand: json['brand'] ?? '',
    );
  }
}

class BillingAddress {
  final String name;
  final String? phone;
  final String billingAddress;

  BillingAddress({
    required this.name,
    required this.phone,
    required this.billingAddress,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    return BillingAddress(
      name: json['name'] ?? '',
      phone: json['phone'],
      billingAddress: json['billing_address'] ?? '',
    );
  }
}

class ShippingAddress {
  final String name;
  final String? phone;
  final String shippingAddress;

  ShippingAddress({
    required this.name,
    required this.phone,
    required this.shippingAddress,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json['name'] ?? '',
      phone: json['phone'],
      shippingAddress: json['shipping_address'] ?? '',
    );
  }
}

