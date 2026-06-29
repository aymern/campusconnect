import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract class EmergencyRepository {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> getAlertHistory();
  Future<void> saveAlert(Map<String, dynamic> alert);
}

class SqliteEmergencyRepository implements EmergencyRepository {
  SqliteEmergencyRepository({Database? database}) : _database = database;

  final Database? _database;
  Database? _db;

  @override
  Future<void> initialize() async {
    _db ??= _database ?? await openDatabase(
      p.join(await getDatabasesPath(), 'campusconnect_emergency.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE emergency_alerts (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            latitude REAL,
            longitude REAL,
            address TEXT,
            message TEXT,
            created_at TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAlertHistory() async {
    await initialize();
    final rows = await _db!.query('emergency_alerts', orderBy: 'created_at DESC');
    return rows;
  }

  @override
  Future<void> saveAlert(Map<String, dynamic> alert) async {
    await initialize();
    await _db!.insert('emergency_alerts', alert, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
