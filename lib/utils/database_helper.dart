import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final String _databaseName = "sudokudb6.db";
  static final int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE tb_sudoku (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nivel INT,
        dificuldade TEXT,
        tabuleiro TEXT,
        solucao TEXT
      )
    """);
  }

  Future<void> deleteAndCloseDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);

    final databaseFile = File(path);

    if (await databaseFile.exists()) {
      await databaseFile.delete();
    } else {}
  }
}
