class SyncOperation {
  const SyncOperation({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.attempts = 0,
    this.status = 'pending',
  });

  final String id;
  final String type;
  final String payload;
  final DateTime createdAt;
  final int attempts;
  final String status;

  SyncOperation copyWith({
    String? id,
    String? type,
    String? payload,
    DateTime? createdAt,
    int? attempts,
    String? status,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'payload': payload,
      'created_at': createdAt.toIso8601String(),
      'attempts': attempts,
      'status': status,
    };
  }

  factory SyncOperation.fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id'] as String,
      type: map['type'] as String,
      payload: map['payload'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      attempts: (map['attempts'] as int?) ?? 0,
      status: map['status'] as String? ?? 'pending',
    );
  }
}
