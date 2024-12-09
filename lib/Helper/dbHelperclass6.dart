import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Class6 Models/class6_details_model.dart';
import '../Model/Class6 Models/class6_model.dart';

class DbHelperClass6 {
  static Database? _db;

  static Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "class6.db");
    bool dbExists = await File(path).exists();

    // If the database doesn't exist, download it from GitHub
    if (!dbExists) {
      await downloadDbFromGitHub(path);
    }

    // Open the database
    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  static Future<void> downloadDbFromGitHub(String savePath) async {
    const String fileUrl =
        'https://github.com/zarafshanMobologics/Easy-Dictionary-Local-Database/raw/refs/heads/localDB/assets/local_db/class6.db';

    try {
      print('Downloading database file...');

      // HTTP request to download file
      final response = await http.get(Uri.parse(fileUrl));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Save file to the provided savePath
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Database file downloaded successfully: $savePath');
      } else {
        throw Exception(
            'Failed to download database file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading database file: $e');
      throw Exception('Failed to download database file.');
    }
  }

  Future<List<Class6Model>> getClass6LessonTblData() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.rawQuery("SELECT * FROM lesson_tbl");
    print(queryResult);

    return queryResult.map((e) => Class6Model.fromMap(e)).toList();
  }

  Future<List<Class6DetailsModel>> getClass6LessonTblDetailsData() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.rawQuery("SELECT * FROM word_tbl");
    print(queryResult);

    return queryResult.map((e) => Class6DetailsModel.fromMap(e)).toList();
  }
}
