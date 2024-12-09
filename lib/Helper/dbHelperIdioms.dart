import 'dart:io';

// class DbHelperIdioms {
//   static Database? _db;

//   static Future<Database?> get db async {
//     if (_db != null) return _db;
//     _db = await initDb();
//     return _db;
//   }

//   static initDb() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "database.db");
//     bool dbExists = await File(path).exists();

//     if (!dbExists) {
//       ByteData data = await rootBundle.load(join("assets", "database.db"));
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//       // Write and flush the bytes written
//       await File(path).writeAsBytes(bytes, flush: true);
//     }
//     var theDb = await openDatabase(path, version: 1);
//     return theDb;
//   }

//   static Future<List<Map<String, dynamic>>> getProverbsFromDataBase() async {
//     var database = await db;
//     return database!.query("proverbs", orderBy: 'PVID ASC');
//   }

//   static Future<List<Map<String, dynamic>>> getFavProverbsFromDataBase() async {
//     var database = await db;
//     return database!
//         .rawQuery('''select * from proverbs where favorite = ?''', [1]);
//   }

//   static Future<List<Map<String, dynamic>>>
//       getBritishSlangsFromDataBase() async {
//     var database = await db;
//     return database!.rawQuery(
//       '''SELECT * FROM Slangs WHERE Country LIKE ?''',
//       ['Br%'],
//     );
//   }

//   static Future updateProverbs(
//       Map<String, int> id, Map<String, int> fav) async {
//     var database = await db;
//     database!.rawUpdate('''
//     UPDATE proverbs
//     SET Favorite = ?
//     WHERE PVID = ?
//     ''', [fav['Favorite'], id['PVID']]);
//   }

//   static Future<List<Map<String, dynamic>>>
//       getFavoriteBritishSlangsFromDATABASE() async {
//     var database = await db;
//     return database!.rawQuery('''SELECT * from Slangs
//     WHERE Country LIKE ?
//     AND Favorite = ?

//     ''', ['Br%', 1]);
//   }

//   static Future<List<Map<String, dynamic>>>
//       getAmericanSlangsFromDataBase() async {
//     var database = await db;
//     return database!.rawQuery(
//       '''
//   SELECT * from Slangs
//   Where Country LIKE ?
// ''',
//       ['AM%'],
//     );
//   }

//   static Future updateBritishSlangs(
//       Map<String, int> id, Map<String, int> fav) async {
//     var database = await db;
//     database!.rawUpdate(
//       '''UPDATE Slangs
//     SET Favorite = ?
//     WHERE SlangID =?
//     ''',
//       [fav['Favorite'], id['SlangID']],
//     );
//   }

//   static Future updateAmericanSlangsDb(
//     Map<String, int> id,
//     Map<String, int> fav,
//   ) async {
//     var database = await db;
//     database!.rawUpdate(
//       '''UPDATE Slangs
//     SET Favorite = ?
//     WHERE SlangID =?
//     ''',
//       [fav['Favorite'], id['SlangID']],
//     );
//   }

//   static Future<List<Map<String, dynamic>>>
//       getFavoriteAmericanSlangsFromDATABASE() async {
//     var database = await db;
//     return database!.rawQuery('''SELECT * from Slangs
//     WHERE Country LIKE ?
//     AND Favorite = ?

//     ''', ['Am%', 1]);
//   }

//   static Future<List<Map<String, dynamic>>> getCategoriesFromDb() async {
//     var dataBase = await db;
//     return dataBase!.rawQuery('''
//         select * from Categories
//         LIMIT 31;
//       ''');
//   }

//   static Future<List<Map<String, dynamic>>> getDataBasedOnCategoriesFromDB(
//       int id) async {
//     var database = await db;
//     return database!.rawQuery(
//       '''
//   select * from Idioms where CatID = ?;
// ''',
//       [id],
//     );
//   }

//   static Future updateSubCategories(
//     Map<String, int> id,
//     Map<String, int> fav,
//   ) async {
//     var database = await db;
//     database!.rawUpdate(
//       '''
//   UPDATE Idioms
//   Set favorite = ?
//   WHERE iID =?
//   ''',
//       [
//         fav['favorite'],
//         id['iID'],
//       ],
//     );
//   }

//   static Future<List<Map<String, dynamic>>> getFavSubCategory(int id) async {
//     var database = await db;
//     return database!.rawQuery('''SELECT * from Idioms
//     WHERE CatID = ?
//     AND Favorite = ?

//     ''', [id, 1]);
//   }
// }

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelperIdioms {
  static Database? _db;

  static Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
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
        'https://github.com/zarafshanMobologics/Easy-Dictionary-Local-Database/raw/refs/heads/localDB/assets/local_db/database.db';

    try {
      print('Downloading database file...');

      // Download file using http
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

  static Future<List<Map<String, dynamic>>> getProverbsFromDataBase() async {
    var database = await db;
    return database!.query("proverbs", orderBy: 'PVID ASC');
  }

  static Future<List<Map<String, dynamic>>> getFavProverbsFromDataBase() async {
    var database = await db;
    return database!
        .rawQuery('''SELECT * FROM proverbs WHERE favorite = ?''', [1]);
  }

  static Future<List<Map<String, dynamic>>>
      getBritishSlangsFromDataBase() async {
    var database = await db;
    return database!.rawQuery(
      '''SELECT * FROM Slangs WHERE Country LIKE ?''',
      ['Br%'],
    );
  }

  static Future updateProverbs(
      Map<String, int> id, Map<String, int> fav) async {
    var database = await db;
    database!.rawUpdate('''
    UPDATE proverbs 
    SET Favorite = ? 
    WHERE PVID = ?
    ''', [fav['Favorite'], id['PVID']]);
  }

  static Future<List<Map<String, dynamic>>>
      getFavoriteBritishSlangsFromDATABASE() async {
    var database = await db;
    return database!.rawQuery('''SELECT * FROM Slangs 
    WHERE Country LIKE ? 
    AND Favorite = ? 
    ''', ['Br%', 1]);
  }

  static Future<List<Map<String, dynamic>>>
      getAmericanSlangsFromDataBase() async {
    var database = await db;
    return database!.rawQuery(
      '''
  SELECT * FROM Slangs 
  WHERE Country LIKE ?
  ''',
      ['AM%'],
    );
  }

  static Future updateBritishSlangs(
      Map<String, int> id, Map<String, int> fav) async {
    var database = await db;
    database!.rawUpdate(
      '''UPDATE Slangs 
    SET Favorite = ? 
    WHERE SlangID = ?
    ''',
      [fav['Favorite'], id['SlangID']],
    );
  }

  static Future updateAmericanSlangsDb(
    Map<String, int> id,
    Map<String, int> fav,
  ) async {
    var database = await db;
    database!.rawUpdate(
      '''UPDATE Slangs 
    SET Favorite = ? 
    WHERE SlangID = ?
    ''',
      [fav['Favorite'], id['SlangID']],
    );
  }

  static Future<List<Map<String, dynamic>>>
      getFavoriteAmericanSlangsFromDATABASE() async {
    var database = await db;
    return database!.rawQuery('''SELECT * FROM Slangs 
    WHERE Country LIKE ? 
    AND Favorite = ? 
    ''', ['Am%', 1]);
  }

  static Future<List<Map<String, dynamic>>> getCategoriesFromDb() async {
    var database = await db;
    return database!.rawQuery('''SELECT * FROM Categories LIMIT 31;''');
  }

  static Future<List<Map<String, dynamic>>> getDataBasedOnCategoriesFromDB(
      int id) async {
    var database = await db;
    return database!.rawQuery(
      '''SELECT * FROM Idioms WHERE CatID = ?;''',
      [id],
    );
  }

  static Future updateSubCategories(
    Map<String, int> id,
    Map<String, int> fav,
  ) async {
    var database = await db;
    database!.rawUpdate(
      '''
  UPDATE Idioms
  SET favorite = ? 
  WHERE iID = ?
  ''',
      [fav['favorite'], id['iID']],
    );
  }

  static Future<List<Map<String, dynamic>>> getFavSubCategory(int id) async {
    var database = await db;
    return database!.rawQuery(
        '''SELECT * FROM Idioms WHERE CatID = ? AND Favorite = ?''', [id, 1]);
  }
}
