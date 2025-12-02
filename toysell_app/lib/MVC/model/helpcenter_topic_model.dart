class HelpCenterTopic {
  final int id;
  final String topic;
  final String slug;
  final int? parentId;
  final int sequence;
  final String? content;
  final int status;
  final String createdAt;
  final String updatedAt;
  final List<HelpCenterTopic> subtopics;

  HelpCenterTopic({
    required this.id,
    required this.topic,
    required this.slug,
    this.parentId,
    required this.sequence,
    this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.subtopics,
  });

  factory HelpCenterTopic.fromJson(Map<String, dynamic> json) {
    return HelpCenterTopic(
      id: json['id'] ?? 0,
      topic: json['topic'] ?? '',
      slug: json['slug'] ?? '',
      parentId: json['parent_id'],
      sequence: json['sequence'] ?? 0,
      content: json['content'],
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      subtopics: (json['subtopics'] as List? ?? [])
          .map((subtopic) => HelpCenterTopic.fromJson(subtopic))
          .toList(),
    );
  }
}
