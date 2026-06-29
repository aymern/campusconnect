import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/notification_item.dart';
import '../models/notification_model.dart';

abstract class NotificationRepository {
  Future<void> initialize();
  Future<List<NotificationModel>> getHistory();
  Future<void> saveNotification(NotificationModel notification);
  Future<void> markAsRead(String id);
  Future<void> markAllRead();
  Future<int> unreadCount();
}

class SqliteNotificationRepository implements NotificationRepository {
  SqliteNotificationRepository({Database? database}) : _database = database;

  final Database? _database;
  Database? _db;

  @override
  Future<void> initialize() async {
    _db ??= _database ?? await openDatabase(
      p.join(await getDatabasesPath(), 'campusconnect_notifications.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notifications (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            created_at TEXT NOT NULL,
            is_read INTEGER NOT NULL,
            topic TEXT,
            payload TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<NotificationModel>> getHistory() async {
    await initialize();
    final rows = await _db!.query(
      'notifications',
      orderBy: 'created_at DESC',
    );

    return rows.map(NotificationModel.fromMap).toList(growable: false);
  }

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    await initialize();
    await _db!.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> markAsRead(String id) async {
    await initialize();
    await _db!.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markAllRead() async {
    await initialize();
    await _db!.update(
      'notifications',
      {'is_read': 1},
      where: 'is_read = 0',
    );
  }

  @override
  Future<int> unreadCount() async {
    await initialize();
    final result = await _db!.rawQuery(
      'SELECT COUNT(*) as count FROM notifications WHERE is_read = 0',
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
