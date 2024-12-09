import 'package:easy_dictionary_latest/Helper/dbHelper.dart';
import 'package:easy_dictionary_latest/Model/dbModel.dart';
import 'package:flutter/cupertino.dart';

class FavoritePageProvider with ChangeNotifier {
  List<DbModel> dataList = [];
  DbHelper? dbHelper = DbHelper();
  late Future myFuture;

  bool _isKeyboardActive = false;
  bool get isKeyboardActive => _isKeyboardActive;

  void SetkeybaordActive(bool value) {
    _isKeyboardActive = value;
    notifyListeners();
  }

  Future loadData() async {
    dataList.clear();
    // DbHelper? dbHelper = DbHelper();
    var data = await dbHelper!.getData();

    for (int i = 0; i < data.length; i++) {
      dataList.add(DbModel(
        antonyms: data[i].antonyms,
        definition: data[i].definition,
        partOfSpeech: data[i].partOfSpeech,
        synonyms: data[i].synonyms,
        word: data[i].word,
      ));
    }
    notifyListeners();
  }

  Future loadDataSep() async {
    dataList.clear();
    DbHelper? dbHelper = DbHelper();
    var data = await dbHelper.getData();

    for (int i = 0; i < data.length; i++) {
      dataList.add(DbModel(
        antonyms: data[i].antonyms,
        definition: data[i].definition,
        partOfSpeech: data[i].partOfSpeech,
        synonyms: data[i].synonyms,
        word: data[i].word,
      ));
    }
  }

  Future deleteAllFavorite() async {
    await dbHelper!.deleteAllDictionary();
    loadData();
  }
}
