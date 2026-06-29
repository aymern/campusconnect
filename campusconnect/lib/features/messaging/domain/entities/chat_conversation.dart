class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastActivity,
    required this.unreadCount,
    required this.participantIds,
  });

  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastActivity;
  final int unreadCount;
  final List<String> participantIds;
}
