import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:demo_app/model/post_model.dart';

class SQLiteDbProvider {
  static const _databaseName = "posts.db";
  static const _databaseVersion = 1;

  static const table = 'post_table';

  static const columnUserId = 'userId';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnBody = 'body';
  static const columnFav = 'fav';

  SQLiteDbProvider._();

  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnUserId INTEGER,
            $columnId INTEGER,
            $columnTitle TEXT NOT NULL,
            $columnBody TEXT NOT NULL,
            $columnFav INTEGER NOT NULL DEFAULT 0
          )
          ''');
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<PostModel>> getAllPosts() async {
    final db = await database;
    var results = await db?.query(table, orderBy: "$columnId DESC");
    List<PostModel> products = [];
    for (var result in results!) {
      PostModel model = PostModel.fromJson(result);
      products.add(model);
    }
    return products;
  }

  Future<PostModel?> getLastPosts() async {
    final db = await database;
    var results = await db?.query(table, orderBy: "$columnId DESC", limit: 1);
    for (var result in results!) {
      PostModel model = PostModel.fromJson(result);
      return model;
    }
    return null;
  }

  Future<PostModel?> getProductById(int id) async {
    final db = await database;
    var result = await db?.query(table, where: "id = ", whereArgs: [id]);
    return result!.isNotEmpty ? PostModel.fromJson(result.first) : null;
  }

  Future<int?> insert(PostModel model) async {
    final db = await database;
    var result = await db?.rawInsert(
        "INSERT Into $table ($columnUserId, $columnId, $columnTitle, $columnBody, $columnFav)"
        " VALUES (?, ?, ?, ?, ?)",
        [
          model.userId,
          model.id,
          model.title,
          model.body,
          model.isFavourite ? 0 : 1
        ]);
    return result;
  }

  update(PostModel model) async {
    final db = await database;
    var result = await db
        ?.update(table, model.toJson(), where: "id = ?", whereArgs: [model.id]);
    return result;
  }

  delete(PostModel model) async {
    final db = await database;
    db?.delete(table, where: "id = ?", whereArgs: [model.id]);
  }
}
