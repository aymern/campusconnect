class CampusNotification {
  const CampusNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime createdAt;
  final bool isRead;

  CampusNotification copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return CampusNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
