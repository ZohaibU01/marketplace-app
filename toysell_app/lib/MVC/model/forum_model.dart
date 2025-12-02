import 'userModel.dart';

class ForumPost {
  int id;
  int userId;
  String caption;
  String imagePath;
  String createdAt;
  String updatedAt;
  UserModel user;
  List<Tag> tags;
  List<Comment> comments;
  List<Like> likes;
  List<Share> shares;

  ForumPost({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.tags,
    required this.comments,
    required this.likes,
    required this.shares,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    String? processedImagePath = json['image_path'] != null &&
        !json['image_path'].startsWith('https:')
        ? "https://toysell.hboxdigital.website/storage/${json['image_path']}"
        : json['image_path'];

    return ForumPost(
      id: json['id'],
      userId: json['user_id'],
      caption: json['caption'],
      imagePath: processedImagePath ?? "",
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: UserModel.fromJson(json['user']),
      tags: (json['tags'] as List).map((tag) => Tag.fromJson(tag)).toList(),
      comments: (json['comments'] as List).map((comment) => Comment.fromJson(comment)).toList(),
      likes: (json['likes'] as List).map((like) => Like.fromJson(like)).toList(),
      shares: (json['shares'] as List).map((share) => Share.fromJson(share)).toList(),
    );
  }

  ForumPost copyWith({
    List<Like>? likes,
    List<Comment>? comments,
    List<Tag>? tags,
    List<Share>? shares,
    String? caption,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
    UserModel? user,
    int? id,
    int? userId,
  }) {
    return ForumPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caption: caption ?? this.caption,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      tags: tags ?? this.tags,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      shares: shares ?? this.shares,
    );
  }
}

class Tag {
  int id;
  String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Comment {
  int id;
  int userId;
  int postId;
  String content;
  String? parentId;
  String createdAt;
  String updatedAt;
  UserModel user;
  List<Like> likes;
  List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.likes,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      content: json['content'],
      parentId: json['parent_id']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: UserModel.fromJson(json['user']),
      likes: (json['likes'] as List).map((like) => Like.fromJson(like)).toList(),
      replies: json['replies'] == null ? [] : (json['replies'] as List).map((reply) => Comment.fromJson(reply)).toList(),
    );
  }

  Comment copyWith({
    List<Like>? likes,
    List<Comment>? replies,
    String? content,
    String? createdAt,
    String? updatedAt,
    UserModel? user,
    int? id,
    int? userId,
    int? postId,
    String? parentId,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
    );
  }
}

class Like {
  int id;
  int userId;
  String likeableType;
  int likeableId;
  String createdAt;
  String updatedAt;

  Like({
    required this.id,
    required this.userId,
    required this.likeableType,
    required this.likeableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      userId: json['user_id'],
      likeableType: json['likeable_type'],
      likeableId: json['likeable_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Share {
  int id;
  int userId;
  int postId;
  String createdAt;
  String updatedAt;

  Share({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Share.fromJson(Map<String, dynamic> json) {
    return Share(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
