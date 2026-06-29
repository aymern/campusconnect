import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: chatProvider.conversations.length,
        itemBuilder: (context, index) {
          final conversation = chatProvider.conversations[index];
          return ListTile(
            title: Text(conversation.title),
            subtitle: Text(conversation.lastMessage),
            trailing: conversation.unreadCount > 0
                ? CircleAvatar(radius: 12, child: Text('${conversation.unreadCount}'))
                : null,
            onTap: () {
              Navigator.of(context).pushNamed('/messages/conversation', arguments: conversation.id);
            },
          );
        },
      ),
    );
  }
}
