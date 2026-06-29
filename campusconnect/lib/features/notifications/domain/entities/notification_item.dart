class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.topic,
    this.payload,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final String? topic;
  final String? payload;

  AppNotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? topic,
    String? payload,
  }) {
    return AppNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      topic: topic ?? this.topic,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
      'topic': topic,
      'payload': payload,
    };
  }

  factory AppNotificationItem.fromMap(Map<String, dynamic> map) {
    return AppNotificationItem(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      isRead: (map['is_read'] as int?) == 1,
      topic: map['topic'] as String?,
      payload: map['payload'] as String?,
    );
  }
}
