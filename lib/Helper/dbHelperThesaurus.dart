import 'dart:io';

import 'package:easy_dictionary_latest/Model/thesaurusModel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelperThesaurus {
  static Database? _db;

  static Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "thesaurus.db");
    bool dbExists = await File(path).exists();

    // If the database file does not exist, download it
    if (!dbExists) {
      await downloadDbFromGitHub(path);
    }

    // Open the database
    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  static Future<void> downloadDbFromGitHub(String savePath) async {
    const String fileUrl =
        'https://github.com/zarafshanMobologics/Easy-Dictionary-Local-Database/raw/refs/heads/localDB/assets/local_db/thesaurus.db';

    try {
      print('Downloading thesaurus database file...');

      // Download the file using HTTP
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        // Save the downloaded database file
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes, flush: true);
        print('Thesaurus database file downloaded successfully: $savePath');
      } else {
        throw Exception(
            'Failed to download thesaurus database file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading thesaurus database file: $e');
      throw Exception('Failed to download thesaurus database file.');
    }
  }

  Future<List<ThesaurusModel>> getSearchWordData() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery(
        "SELECT * FROM description ORDER BY synonyms ASC LIMIT 15000 OFFSET 1200");

    return queryResult.map((e) => ThesaurusModel.fromMap(e)).toList();
  }

  Future<List<ThesaurusModel>> getSearchWordRemainingData() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery(
        "SELECT * FROM description ORDER BY synonyms ASC LIMIT 25000 OFFSET 15200");

    return queryResult.map((e) => ThesaurusModel.fromMap(e)).toList();
  }
}
