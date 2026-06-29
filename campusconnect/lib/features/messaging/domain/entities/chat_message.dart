class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.isMine,
    required this.isRead,
    required this.isTyping,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isMine;
  final bool isRead;
  final bool isTyping;
}
