import '../../domain/entities/notification_item.dart';

class NotificationModel extends AppNotificationItem {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    super.isRead = false,
    super.topic,
    super.payload,
  });

  factory NotificationModel.fromEntity(AppNotificationItem item) {
    return NotificationModel(
      id: item.id,
      title: item.title,
      body: item.body,
      createdAt: item.createdAt,
      isRead: item.isRead,
      topic: item.topic,
      payload: item.payload,
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

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
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
