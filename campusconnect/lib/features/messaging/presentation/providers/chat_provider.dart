import 'package:flutter/foundation.dart';

import '../../data/repositories/message_repository.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(this._repository);

  final MessageRepository _repository;
  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: 'conv-campus',
      title: 'Campus Hub',
      lastMessage: 'Welcome to the campus messaging hub.',
      lastActivity: DateTime.now(),
      unreadCount: 1,
      participantIds: const ['student', 'staff'],
    ),
  ];

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isLoading = false;

  List<ChatConversation> get conversations => List.unmodifiable(_conversations);
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;

  Future<void> loadConversation(String conversationId) async {
    _isLoading = true;
    notifyListeners();

    final cachedMessages = await _repository.getMessages(conversationId);
    _messages
      ..clear()
      ..addAll(cachedMessages);
    await _repository.markAsRead(conversationId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final message = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: 'student',
      content: content,
      timestamp: DateTime.now(),
      isMine: true,
      isRead: true,
      isTyping: false,
    );

    await _repository.saveMessage(message);
    _messages.add(message);
    _isTyping = false;
    notifyListeners();
  }

  void setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }
}
