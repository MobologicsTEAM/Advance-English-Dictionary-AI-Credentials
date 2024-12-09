import 'dart:io';

// class DbHelperQuiz {
//   static Database? _db;

//   static Future<Database?> get db async {
//     if (_db != null) return _db;
//     _db = await initDb();
//     return _db;
//   }

//   static initDb() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "db_prahse.db");
//     bool dbExists = await File(path).exists();

//     if (!dbExists) {
//       ByteData data = await rootBundle.load(join("assets", "db_prahse.db"));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//       // Write and flush the bytes written
//       await File(path).writeAsBytes(bytes, flush: true);
//     }
//     var theDb = await openDatabase(path, version: 1);
//     return theDb;
//   }

//   Future<List<QuizModel>> getQuizData() async {
//     var dbClient = await db;

//     final List<Map<String, Object?>> queryResult =
//         await dbClient!.rawQuery("SELECT * FROM ReadTestQuiz");

//     print(queryResult);

//     return queryResult.map((e) => QuizModel.fromMap(e)).toList();
//   }
// }

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/quizModel.dart';

class DbHelperQuiz {
  static Database? _db;

  static Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "db_prahse.db");
    bool dbExists = await File(path).exists();

    // Check if the database file exists; if not, download it
    if (!dbExists) {
      await downloadDbFromGitHub(path);
    }

    // Open the database
    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  static Future<void> downloadDbFromGitHub(String savePath) async {
    const String fileUrl =
        'https://github.com/zarafshanMobologics/Easy-Dictionary-Local-Database/raw/refs/heads/localDB/assets/local_db/db_prahse.db';

    try {
      print('Downloading database file...');

      // Download the file using HTTP
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        // Save the downloaded database file
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes, flush: true);
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

  Future<List<QuizModel>> getQuizData() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.rawQuery("SELECT * FROM ReadTestQuiz");

    print(queryResult);

    return queryResult.map((e) => QuizModel.fromMap(e)).toList();
  }
}