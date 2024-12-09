import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../Helper/dbHelperOfflineDictionary.dart';
import '../Model/offline_dictionary_model.dart';

class OfflineDictionaryProvider with ChangeNotifier {
  late List<OfflineDictionary> wordData;
  List<int> _shownIndexes = [];

  Future loadOfflineDictionaryData() async {
    DbHelperOfflineDictionary? offlineDictionaryProvider =
        DbHelperOfflineDictionary();
    wordData = await offlineDictionaryProvider.getsearchWordData();
    print(wordData);
    notifyListeners();
    print(wordData);
    return wordData;
  }

  String text = '';

  UnmodifiableListView<OfflineDictionary> get wordList {
    return text.isEmpty
        ? UnmodifiableListView(wordData)
        : UnmodifiableListView(wordData.where((element) =>
            element.word.toLowerCase().contains(text.toLowerCase())));
  }

  void changeText(String searchword) {
    text = searchword;
    notifyListeners();
  }

  int notification_word() {
    // generates a new Random object
    final _random = Random();

    // Check if all words have been shown
    if (_shownIndexes.length >= wordData.length) {
      _shownIndexes.clear(); // Reset the list if all words have been shown
    }

    int randomIndex;

    do {
      randomIndex = _random.nextInt(wordData.length);
    } while (_shownIndexes.contains(randomIndex)); // Ensure unique index

    _shownIndexes.add(randomIndex); // Track the shown index

    return randomIndex;
  }
}
