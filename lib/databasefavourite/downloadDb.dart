import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DownloadDatabaseHelper {
  //Create a private constructor
  DownloadDatabaseHelper._();

  static const databaseName = 'download.db';
  static final DownloadDatabaseHelper instance = DownloadDatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE download(id	INTEGER,image	TEXT,link	TEXT,PRIMARY KEY(id AUTOINCREMENT))");
    });
  }

  /// set into table
  insertTodo(DownloadModel todo) async {
    print('INSERT ++++++ ');
    try {
      final db = await database;
      var res = await db
          .insert(DownloadModel.TABLENAME, todo.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) => ("inserted data>>>>>>>>>>"));
      return res;
    } catch (e) {
      ('ERROR IN INSERT $e');
    }
  }

  /// get table
  Future<List<DownloadModel>> retrieveTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(DownloadModel.TABLENAME);
    return List.generate(maps.length, (i) {
      return DownloadModel(
        id: maps[i]['id'],
        image: maps[i]['image'],
        link: maps[i]['link'],
      );
    });
  }

  updateTodo(DownloadModel todo) async {
    final db = await database;
    await db.update(DownloadModel.TABLENAME, todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteTodo(int id) async {
    var db = await database;
    db.delete(DownloadModel.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}

class DownloadModel {
  final int id;
  final String image;
  final String link;

  static const String TABLENAME = "download";

  DownloadModel({
    this.id,
    this.image,
    this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'link': link,
    };
  }
}
