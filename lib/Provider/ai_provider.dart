import 'dart:convert';

import 'package:easy_dictionary_latest/Helper/dbHelper.dart';
import 'package:easy_dictionary_latest/Model/ai_word_detail_model.dart';
import 'package:easy_dictionary_latest/Model/dbModel.dart';
import 'package:easy_dictionary_latest/Model/searchWordModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//final String apiKey = "AIzaSyBqvpmqEUsI7jwHEjfjTW1DCcEhCgup8pQ";

class GeminiAPIController extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;
  WordDataAI? _result;
  bool search = false;
  late DbHelper db;
  bool _isfavourite = false;
  bool get isFavourite => _isfavourite;
  List<DbModel> favoriteList = [];

  bool get isLoading => _isLoading;
  WordDataAI? get result => _result;

  void setResult(WordDataAI? result) {
    _result = result;
    notifyListeners();
  }

  void setFavourite(bool fav) {
    _isfavourite = fav;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> getGeminiData(String userMessage) async {
    setLoading(true);
    _isfavourite = false;
    try {
      String prompt =
          "i want the meaning,synonyms,antonyms,part of speech for the word ${userMessage} with two examples and the result give me in JSON,1. 'word': 'value','partOfSpeech':'value' 'meaning': 'value',3. 'synonyms': [values],4.'antonyms': [values].5. 'examples': [values] and use only english language in response";
      String apiKey =
          'AIzaSyBqvpmqEUsI7jwHEjfjTW1DCcEhCgup8pQ'; // Put your API key here

      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': '$prompt}',
              }
            ]
          }
        ],
      };

      String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        var content =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        content =
            '''${content.replaceAll('JSON', '').replaceAll('```', '').replaceAll('json', '')} ''';

        var contentJson = jsonDecode(content) as Map<String, dynamic>;

        setResult(WordDataAI.fromJson(contentJson));

        db = await DbHelper();
        await db.initDataBase();
        favoriteList = await db.getData();

        insertsearchword();
      }
    } catch (e) {
      setResult(null);
    }

    setLoading(false);
  }

  void insertsearchword() async {
    db.insertSearchDictionary(
        SearchWord(word: _result?.word, definition: _result?.meaning));
    print('SearchWordDataAdded');
  }

  Future<void> favInsertData() async {
    String synonyms = updateWithMobologics(result?.synonyms);
    String antonyms = updateWithMobologics(result?.antonyms);
    db.insert(DbModel(
      word: result?.word,
      partOfSpeech: result?.partOfSpeech,
      definition: result?.meaning,
      synonyms: synonyms,
      antonyms: antonyms,
    ));

    notifyListeners();
  }

  String updateWithMobologics(list) {
    String result = '';
    for (int i = 0; i < list.length; i++) {
      result = result + list[i] + ' mobologics ';
    }
    return result;
  }

  void toggleFavorite() async {
    if (_result != null) {
      if (_isfavourite) {
        await db.deleteSpecificSearchWord(
            _result!.word); // Implement remove method in DbHelper
      } else {
        await favInsertData();
      }
      setFavourite(!_isfavourite);
    }
  }

  // Add a method to clear the controller's data
  void clearData() {
    print("-----------------");
    print('clear the screen');
    _result = null;
    textEditingController.clear();
    notifyListeners();
  }
}
