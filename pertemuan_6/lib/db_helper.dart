import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'catatan.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _dbName = 'catatan.db';
  static const _dbVersion = 1;
  static const tabel = 'catatan';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    DatabaseFactory dbFactory;
    String path;

    if (kIsWeb) {
      // Menggunakan databaseFactoryFfiWeb dengan inisialisasi yang lebih aman
      dbFactory = databaseFactoryFfiWeb;
      path = _dbName;
    } else {
      dbFactory = databaseFactory;
      final dir = await getDatabasesPath();
      path = join(dir, _dbName);
    }

    try {
      return await dbFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: _dbVersion,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE $tabel (
                id          INTEGER PRIMARY KEY AUTOINCREMENT,
                judul       TEXT    NOT NULL,
                isi         TEXT    NOT NULL,
                kategori    TEXT    NOT NULL,
                email       TEXT    NOT NULL,
                dibuat_pada INTEGER NOT NULL
              )
            ''');
          },
        ),
      );
    } catch (e) {
      // Fallback sederhana jika SQLite Web gagal total
      if (kIsWeb) {
        debugPrint('SQLite Web Error: $e. Menggunakan In-Memory Database sebagai fallback.');
        return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      }
      rethrow;
    }
  }

  Future<int> insert(Catatan c) async {
    final db = await database;
    return db.insert(tabel, c.toMap());
  }

  Future<List<Catatan>> getAll() async {
    final db = await database;
    final rows = await db.query(tabel, orderBy: 'dibuat_pada DESC');
    return rows.map(Catatan.fromMap).toList();
  }

  Future<int> update(Catatan c) async {
    assert(c.id != null);
    final db = await database;
    return db.update(tabel, c.toMap(),
        where: 'id = ?', whereArgs: [c.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(tabel, where: 'id = ?', whereArgs: [id]);
  }
}
