// Chat List Models

class ChatListResponse {
  final bool error;
  final String message;
  final ChatListData data;

  ChatListResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    return ChatListResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: ChatListData.fromJson(json['data']),
    );
  }
}


// Chat  Models

class ChatResponse {
  final bool error;
  final String message;
  final ChatItem data;

  ChatResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: ChatItem.fromJson(json['data']),
    );
  }
}

class ChatListData {
  final int currentPage;
  final List<ChatItem> chatItems;
  final int total;

  ChatListData({
    required this.currentPage,
    required this.chatItems,
    required this.total,
  });

  factory ChatListData.fromJson(Map<String, dynamic> json) {
    return ChatListData(
      currentPage: json['current_page'] ?? 1,
      chatItems: (json['data'] as List? ?? []).map((e) => ChatItem.fromJson(e)).toList(),
      total: json['total'] ?? 0,
    );
  }
}

class ChatItem {
  final int id;
  final int sellerId;
  final int buyerId;
  final int itemId;
  final String status;
  final double amount;
  final bool userBlocked;
  final String? lastMessageTime;
  final User seller;
  final User buyer;
  final ChatItemDetails item;

  ChatItem({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.itemId,
    required this.status,
    required this.amount,
    required this.userBlocked,
    this.lastMessageTime,
    required this.seller,
    required this.buyer,
    required this.item,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      buyerId: json['buyer_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      status: json['status']?.toString() ?? '0',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      userBlocked: json['user_blocked'] ?? false,
      lastMessageTime: json['last_message_time'],
      seller: User.fromJson(json['seller']),
      buyer: User.fromJson(json['buyer']),
      item: ChatItemDetails.fromJson(json['item']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String? profile;

  User({
    required this.id,
    required this.name,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profile: json['profile'] ?? "https://static.vecteezy.com/system/resources/previews/021/548/095/non_2x/default-profile-picture-avatar-user-avatar-icon-person-icon-head-icon-profile-picture-icons-default-anonymous-user-male-and-female-businessman-photo-placeholder-social-network-avatar-portrait-free-vector.jpg",
    );
  }
}

class ChatItemDetails {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String status;
  final bool isPurchased;

  ChatItemDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.status,
    required this.isPurchased,
  });

  factory ChatItemDetails.fromJson(Map<String, dynamic> json) {
    return ChatItemDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      isPurchased: json['is_purchased'] == 1,
    );
  }
}
