import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/chat_message_model.dart';

abstract class MessageRepository {
  Future<void> initialize();
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<void> saveMessage(ChatMessageModel message);
  Future<void> markAsRead(String conversationId);
}

class SqliteMessageRepository implements MessageRepository {
  SqliteMessageRepository({Database? database}) : _database = database;

  final Database? _database;
  Database? _db;

  @override
  Future<void> initialize() async {
    _db ??= _database ?? await openDatabase(
      p.join(await getDatabasesPath(), 'campusconnect_messages.db'),
      version: 1,
      onCreate: (db, version) async {
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
      },
    );
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    await initialize();
    final rows = await _db!.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
    return rows.map(ChatMessageModel.fromMap).toList(growable: false);
  }

  @override
  Future<void> saveMessage(ChatMessageModel message) async {
    await initialize();
    await _db!.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    await initialize();
    await _db!.update(
      'messages',
      {'is_read': 1},
      where: 'conversation_id = ? AND is_mine = 0',
      whereArgs: [conversationId],
    );
  }
}
