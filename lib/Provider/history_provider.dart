import 'package:easy_dictionary_latest/Model/searchWordModel.dart';
import 'package:flutter/cupertino.dart';

import '../Helper/dbHelper.dart';

class HistoryProvider with ChangeNotifier {
  DbHelper dbHelper = DbHelper();
  List<SearchWord> dataList = [];

  Future loadData() async {
    dataList.clear();
    var d = await dbHelper.getsearchWordData();
    d
        .map((e) =>
            dataList.add(SearchWord(word: e.word, definition: e.definition)))
        .toList();
    notifyListeners();
  }

  Future DeleteAllSearchDictionary() async {
    dbHelper.deleteAllSearchWordData();
    await loadData();
  }

  Future DeleteSpecificSearchWord(String word) async {
    await dbHelper.deleteSpecificSearchWord(word);
    await loadData();
  }
}
