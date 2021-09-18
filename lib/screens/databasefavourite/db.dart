import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'todos_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
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
          "CREATE TABLE Elearn(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, pdf TEXT,link TEXT, bookid INTEGER, authername TEXT, coverimage TEXT, rating TEXT)");
    });
  }

  /// set into table
  insertTodo(Todo todo) async {
    final db = await database;
    var res = await db
        .insert(Todo.TABLENAME, todo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => ("inserted data>>>>>>>>>>"));
    return res;
  }

  /// get table
  Future<List<Todo>> retrieveTodos() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(Todo.TABLENAME);

    return List.generate(maps.length, (i) {
      ("length:>>>>>>>>>>  ${maps[i]['coverimage']}");
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        bookid: maps[i]['bookid'],
        coverimage: maps[i]['coverimage'],
        link: maps[i]['link'],
        rating: maps[i]['rating'],
        authername: maps[i]['authername'],
        pdf: maps[i]['pdf'],
      );
    });
  }

  updateTodo(Todo todo) async {
    final db = await database;

    await db.update(Todo.TABLENAME, todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteTodo(int id) async {
    var db = await database;
    db.delete(Todo.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }
}

class Todo {
  final int id;
  final int bookid;
  final String rating;
  final String title;
  final String pdf;
  final String link;
  final String authername;
  final String coverimage;
  static const String TABLENAME = "Elearn";

  Todo(
      {this.id,
      this.pdf,
      this.authername,
      this.bookid,
      this.link,
      this.rating,
      this.title,
      this.coverimage});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pdf': pdf,
      'link': link,
      'title': title,
      'rating': rating,
      'bookid': bookid,
      'authername': authername,
      'coverimage': coverimage
    };
  }
}
