import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/sync_operation.dart';

abstract class OfflineCacheRepository {
  Future<void> initialize();
  Future<List<SyncOperation>> getPendingOperations();
  Future<void> enqueueOperation(SyncOperation operation);
  Future<void> updateOperation(SyncOperation operation);
  Future<void> clearCompleted();
}

class SqliteOfflineCacheRepository implements OfflineCacheRepository {
  SqliteOfflineCacheRepository({Database? database}) : _database = database;

  final Database? _database;
  Database? _db;

  @override
  Future<void> initialize() async {
    _db ??= _database ?? await openDatabase(
      p.join(await getDatabasesPath(), 'campusconnect_offline.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sync_queue (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            payload TEXT NOT NULL,
            created_at TEXT NOT NULL,
            attempts INTEGER NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<SyncOperation>> getPendingOperations() async {
    await initialize();
    final rows = await _db!.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
    );

    return rows.map(SyncOperation.fromMap).toList(growable: false);
  }

  @override
  Future<void> enqueueOperation(SyncOperation operation) async {
    await initialize();
    await _db!.insert(
      'sync_queue',
      operation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateOperation(SyncOperation operation) async {
    await initialize();
    await _db!.update(
      'sync_queue',
      operation.toMap(),
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }

  @override
  Future<void> clearCompleted() async {
    await initialize();
    await _db!.delete('sync_queue', where: 'status = ?', whereArgs: ['completed']);
  }
}
