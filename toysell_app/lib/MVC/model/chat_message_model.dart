class ChatMessageResponse {
  final bool error;
  final String message;
  final ChatMessageDataWrapper data;

  ChatMessageResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      data: ChatMessageDataWrapper.fromJson(json['data']),
    );
  }
}

class ChatMessageDataWrapper {
  final Offer offer;
  final ChatPagination chat;

  ChatMessageDataWrapper({
    required this.offer,
    required this.chat,
  });

  factory ChatMessageDataWrapper.fromJson(Map<String, dynamic> json) {
    return ChatMessageDataWrapper(
      offer: Offer.fromJson(json['offer']),
      chat: ChatPagination.fromJson(json['chat']),
    );
  }
}

class Offer {
  final int id;
  final int sellerId;
  final int buyerId;
  final int itemId;
  final int status;
  final double amount;
  final String createdAt;
  final String updatedAt;

  Offer({
    required this.id,
    required this.sellerId,
    required this.buyerId,
    required this.itemId,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      buyerId: json['buyer_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      status: json['status'] ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class ChatPagination {
  final int currentPage;
  final List<ChatMessage> data;
  final int total;

  ChatPagination({
    required this.currentPage,
    required this.data,
    required this.total,
  });

  factory ChatPagination.fromJson(Map<String, dynamic> json) {
    return ChatPagination(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List)
          .map((e) => ChatMessage.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}

class ChatMessage {
  final int id;
  final int senderId;
  final int itemOfferId;
  final String message;
  final String? file;
  final String? audio;
  final String createdAt;
  final String messageType;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.itemOfferId,
    required this.message,
    this.file,
    this.audio,
    required this.createdAt,
    required this.messageType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      itemOfferId: json['item_offer_id'] ?? 0,
      message: json['message'] ?? '',
      file: json['file'] == "" ? null : json['file'],
      audio: json['audio'] == "" ? null : json['audio'],
      createdAt: json['created_at'] ?? '',
      messageType: json['message_type'] ?? 'text',
    );
  }
}
