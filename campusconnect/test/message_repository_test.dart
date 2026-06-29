import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:campusconnect/features/messaging/data/models/chat_message_model.dart';
import 'package:campusconnect/features/messaging/data/repositories/message_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('message repository caches and reads messages', () async {
    final db = await openDatabase(inMemoryDatabasePath, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE messages (
          id TEXT PRIMARY KEY,
          conversation_id TEXT NOT NULL,
          sender_id TEXT NOT NULL,
          content TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          is_mine INTEGER NOT NULL,
          is_read INTEGER NOT NULL,
          is_typing INTEGER NOT NULL
        )
      ''');
    });

    final repository = SqliteMessageRepository(database: db);
    await repository.initialize();

    final message = ChatMessageModel(
      id: 'm1',
      conversationId: 'conv1',
      senderId: 'user-2',
      content: 'Hello',
      timestamp: DateTime.parse('2026-06-29T10:00:00Z'),
      isMine: false,
      isRead: false,
      isTyping: false,
    );

    await repository.saveMessage(message);
    final messages = await repository.getMessages('conv1');

    expect(messages.single.content, 'Hello');
    expect(messages.single.isRead, isFalse);

    await repository.markAsRead('conv1');
    final updated = await repository.getMessages('conv1');
    expect(updated.single.isRead, isTrue);
  });
}
