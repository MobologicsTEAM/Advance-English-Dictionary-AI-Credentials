import 'package:easy_dictionary_latest/Model/dbModel.dart';
import 'package:easy_dictionary_latest/Model/searchWordModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._(); // Singleton instance
  static Database? _db;

  factory DbHelper() =>
      _instance; // Factory constructor to return the singleton instance

  DbHelper._(); // Private constructor

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    // If _db is null, then create database and return it
    _db = await initDataBase();
    return _db;
  }

  //creating data base
  initDataBase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'dictionary.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  //creating data base table
  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE dictionary(word TEXT PRIMARY KEY, partOfSpeech TEXT,definition TEXT, synonyms TEXT, antonyms TEXT)",
    );

    await db.execute(
      "CREATE TABLE searchWord(word TEXT PRIMARY KEY,definition TEXT)",
    );
  }

  Future<DbModel> insert(DbModel dbModel) async {
    var dbClient = await db;
    await dbClient?.insert('dictionary', dbModel.toMap());

    return dbModel;
  }

  Future<List<DbModel>> getData() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('dictionary');

    return queryResult.map((e) => DbModel.fromMap(e)).toList();
  }

  Future<void> deleteSpecificDictionary(String word) async {
    print('deleteee');
    try {
      var dbClient = await db;
      await dbClient!
          .delete('dictionary', where: 'word = ?', whereArgs: [word]);
      print('Deleted $word from dictionary table');
    } catch (e) {
      print('Failed to delete word data: $e');
      rethrow;
    }
  }

  Future<void> deleteAllDictionary() async {
    var dbClient = await db;
    // dbClient!.rawDelete('DELETE FROM dictionary WHERE word = $word');
    await dbClient!.delete('dictionary');
  }

  Future<SearchWord> insertSearchDictionary(SearchWord searchWordModel) async {
    var dbClient = await db;
    dbClient?.insert('searchWord', searchWordModel.toMap());
    return await searchWordModel;
  }

  Future<List<SearchWord>> getsearchWordData() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('searchWord');

    return queryResult.map((e) => SearchWord.fromMap(e)).toList();
  }

  Future<void> deleteSpecificSearchWord(String word) async {
    print('delete search word');
    try {
      var dbClient = await db;
      await dbClient!
          .delete('searchWord', where: 'word = ?', whereArgs: [word]);
      print('Deleted $word from dictionary table');
    } catch (e) {
      print('Failed to delete word data: $e');
      rethrow;
    }
  }

  void deleteAllSearchWordData() async {
    var dbClient = await db;
    // dbClient!.rawDelete('DELETE FROM dictionary WHERE word = $word');
    await dbClient!.delete('searchWord');
  }
}
