import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../messaging/presentation/pages/chat_list_page.dart';
import '../../../messaging/presentation/providers/chat_provider.dart';
import '../../../messaging/data/repositories/message_repository.dart';

/// Messages feature page.
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (_) => ChatProvider(SqliteMessageRepository()),
      child: const ChatListPage(),
    );
  }
}
