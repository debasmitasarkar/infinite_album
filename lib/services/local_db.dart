import 'package:album/models/album.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDb {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'albums.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE albums (
            id INTEGER PRIMARY KEY,
            title TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE photos (
            albumId INTEGER,
            url TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveAlbums(List<Album> albums) async {
    final db = await database;
    for (var album in albums) {
      await db.insert(
        'albums',
        {'id': album.id, 'title': album.title},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Album>> getAlbums() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('albums');
    return List.generate(maps.length, (i) {
      return Album(
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }
}