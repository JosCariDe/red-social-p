import 'package:sqflite/sqflite.dart';

class PostsDatabase {
  static final PostsDatabase instance = PostsDatabase._internal();

  static Database? _database;

  PostsDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/Posts.db';
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        tags TEXT NOT NULL,
        likes INTEGER NOT NULL,
        dislikes INTEGER NOT NULL,
        views INTEGER NOT NULL,
        userId INTEGER NOT NULL
    )
  ''');
  }
}
