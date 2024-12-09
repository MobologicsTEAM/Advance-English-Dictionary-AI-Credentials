import 'dart:convert';

import 'package:easy_dictionary_latest/Helper/dbHelper.dart';
import 'package:easy_dictionary_latest/Model/dbModel.dart';
import 'package:easy_dictionary_latest/Model/modelClass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/searchWordModel.dart';

class HomeAIController extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;
  ModelClass? _result;
  bool search = false;
  late DbHelper db;
  bool _showSuggestions = true; // Suggestion chips visibility
  bool _isfavourite = false;
  bool get isFavourite => _isfavourite;
  List<DbModel> favoriteList = [];
  String? selectedSuggestion;
  bool get showSuggestion => _showSuggestions;

  // Predefined list of words (you can replace this with a dynamic list or API)
  List<String> vocabularySuggestions = [
    // A
    'Accomplish', 'Abiding', 'abient', 'Acquire', 'Abandon', 'Absurd', 'Apathy',
    'Altruism', 'Aficionado', 'abecedarium',

    // B
    'Ball', 'Book', 'Brave', 'Brisk', 'Beneficial', 'Baffling', 'Bellicose',
    'Benevolent', 'Bombastic',

    // C
    'Cat', 'Circle', 'Courage', 'Curious', 'Complex', 'Cogent', 'Cacophony',
    'Convoluted', 'Circumspect',

    // D
    'Dog', 'Dance', 'Diligent', 'Diverse', 'Devious', 'Disparate', 'Dexterous',
    'Defenestration', 'Dichotomy',

    // E
    'Elephant', 'Eat', 'Energy', 'Eloquent', 'Elusive', 'Erratic', 'Enervating',
    'Ephemeral', 'Exacerbate',

    // F
    'Fish', 'Friend', 'Freedom', 'Fierce', 'Fortunate', 'Fickle', 'Fallacy',
    'Flabbergasted', 'Facetious',

    // G
    'Goat', 'Great', 'Grateful', 'Glisten', 'Gracious', 'Galvanize',
    'Garrulous', 'Grandiloquent', 'Gregarious',

    // H
    'Hat', 'Happy', 'Hasty', 'Humble', 'Harmonious', 'Hypocritical',
    'Histrionics', 'Harbinger', 'Hedonistic',

    // I
    'Ice', 'Interesting', 'Intelligent', 'Innocent', 'Irrelevant', 'Inept',
    'Infallible', 'Incongruous', 'Ineffable',

    // J
    'Jump', 'Joy', 'Jolly', 'Jealous', 'Jubilant', 'Jargon', 'Juxtapose',
    'Jingoistic', 'Jocund',

    // K
    'Kite', 'Kind', 'Keen', 'Knowledgeable', 'Kinetic', 'Kingly',
    'Kleptomaniac', 'Kowtow', 'Kafkaesque',

    // L
    'Lion', 'Light', 'Lively', 'Loyal', 'Labyrinth', 'Laudable', 'Languid',
    'Loquacious', 'Lethargic',

    // M
    'Mouse', 'Marvelous', 'Modest', 'Magnificent', 'Mellow', 'Melancholy',
    'Magnanimous', 'Munificent', 'Misanthropic',

    // N
    'Night', 'Nice', 'Needy', 'Noble', 'Nurture', 'Nefarious', 'Nihilistic',
    'Neologism', 'Nomenclature',

    // O
    'Owl', 'Open', 'Optimistic', 'Observant', 'Overcome', 'Obscure',
    'Obstinate', 'Omniscient', 'Opulent',

    // P
    'Play', 'Peace', 'Passionate', 'Persistent', 'Profound', 'Pragmatic',
    'Perspicacious', 'Pervasive', 'Precarious',

    // Q
    'Quick', 'Quiet', 'Quality', 'Quirky', 'Quaint', 'Quandary', 'Quixotic',
    'Quell', 'Quisling',

    // R
    'Rain', 'Ready', 'Righteous', 'Radiant', 'Robust', 'Resilient',
    'Recalcitrant', 'Resolute', 'Recondite',

    // S
    'Sun', 'Small', 'Silent', 'Strong', 'Simple', 'Sincere', 'Serene',
    'Sagacious', 'Surreptitious',

    // T
    'Tree', 'Time', 'Tired', 'Thoughtful', 'Tenacious', 'Tranquil', 'Transient',
    'Taciturn', 'Tumultuous',

    // U
    'Under', 'Uncommon', 'Useful', 'Unique', 'Unwavering', 'Ubiquitous',
    'Usurp', 'Uncanny', 'Unctuous',

    // V
    'Victory', 'Vast', 'Vocal', 'Virtuous', 'Vigilant', 'Volatile', 'Voracious',
    'Vexing', 'Vicissitude',

    // W
    'Walk', 'Warm', 'Wonder', 'Wise', 'Wistful', 'Wrath', 'Whimsical',
    'Winsome', 'Wanderlust',

    // X
    'Xenon', 'Xylophone', 'Xerophilous', 'Xenophobic', 'X-factor', 'Xylograph',
    'Xenial', 'Xylographer',

    // Y
    'Yellow', 'Young', 'Yell', 'Yonder', 'Yearn', 'Yielding', 'Yoke', 'Yuppie',
    'Yaw',

    // Z
    'Zebra', 'Zoom', 'Zesty', 'Zany', 'Zealous', 'Zenith', 'Ziggurat', 'Zipper',
    'Zeitgeist'
  ];

  List<String> filteredSuggestions = [];

  bool get isLoading => _isLoading;
  ModelClass? get result => _result;

  void setResult(ModelClass? result) {
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

  void selectSuggestion(String suggestion) {
    selectedSuggestion = suggestion; // Update the selected word
    textEditingController.text = suggestion; // Show in the TextFormField
    _showSuggestions = false; // Hide suggestions after selection
    notifyListeners(); // Notify UI to update
  }

  void setSuggestion(bool showsugg) {
    _showSuggestions = showsugg;
    notifyListeners();
  }

  void updateSuggestions(String query) {
    // Reset the selected suggestion when the user starts typing
    selectedSuggestion = null;

    // If query is empty, return no suggestions
    if (query.isEmpty) {
      filteredSuggestions = [];
      _showSuggestions = false;
    } else {
      filteredSuggestions = vocabularySuggestions
          .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
          .take(9) // Limit to 6-9 suggestions
          .toList();
      _showSuggestions = true;
    }
    notifyListeners(); // Notify the UI to update
  }

  Future<void> getGeminiData(String userMessage) async {
    setLoading(true);
    _isfavourite = false;
    try {
      String prompt =
          "i want the definition,synonyms,antonyms,part of speech for the word ${userMessage} with two examples and the result give me in JSON,1. 'word': 'value','partOfSpeech':'value' 'definition': 'value',3. 'synonyms': [values],4.'antonyms': [values].5. 'examples': [values] and use only english language in response";
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

        setResult(ModelClass.fromJson(contentJson));

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
        SearchWord(word: _result?.word, definition: _result?.definition));
    print('SearchWordDataAdded ito database');
  }

  Future<void> favInsertData() async {
    String synonyms = updateWithMobologics(result?.synonyms);
    String antonyms = updateWithMobologics(result?.antonyms);
    db.insert(DbModel(
      word: result?.word,
      partOfSpeech: result?.partOfSpeech,
      definition: result?.definition,
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
    selectedSuggestion = null; // Reset the selected suggestion
    _showSuggestions = false; // Hide suggestions if needed
    textEditingController.clear();
    // showSuggestions = false; // Hide suggestions
    notifyListeners();
  }
}
