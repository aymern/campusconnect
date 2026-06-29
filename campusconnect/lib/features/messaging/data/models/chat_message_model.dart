import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.content,
    required super.timestamp,
    required super.isMine,
    required super.isRead,
    required super.isTyping,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      conversationId: map['conversation_id'] as String,
      senderId: map['sender_id'] as String,
      content: map['content'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isMine: (map['is_mine'] as int) == 1,
      isRead: (map['is_read'] as int) == 1,
      isTyping: (map['is_typing'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'is_mine': isMine ? 1 : 0,
      'is_read': isRead ? 1 : 0,
      'is_typing': isTyping ? 1 : 0,
    };
  }
}
