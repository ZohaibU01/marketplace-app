
enum MessageType { text, image, video }

enum sendType { sender, reciver }

class MessageModel {
  final int id;
  final MessageType messageType;
  final String Sendertype;
  final String content;
  final String? media;
  final int userId;
  final DateTime date;

  MessageModel({
    required this.id,
    required this.messageType,
    required this.content,
    required this.Sendertype,
    this.media,
    required this.userId,
    required this.date,
  });
}
