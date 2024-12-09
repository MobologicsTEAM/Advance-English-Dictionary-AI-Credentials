import 'dart:collection';

import 'package:easy_dictionary_latest/Helper/dbHelperThesaurus.dart';
import 'package:easy_dictionary_latest/Model/thesaurusModel.dart';
import 'package:flutter/cupertino.dart';

class TheasaurusPageProvider with ChangeNotifier {
  List<ThesaurusModel> datalist = [];
  List<ThesaurusModel> newdatalist = [];

  Future loadData() async {
    try {
      DbHelperThesaurus? dbHelperThesaurus = DbHelperThesaurus();
      final data = await dbHelperThesaurus.getSearchWordData();

      datalist = data;
      print(datalist.length.toString() + ' list data');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future loadRemaningData() async {
    try {
      DbHelperThesaurus? dbHelperThesaurus = DbHelperThesaurus();
      final newdatalistt = await dbHelperThesaurus.getSearchWordRemainingData();

      newdatalist = newdatalistt;
      datalist.addAll(newdatalist);
      print(datalist.length.toString() + 'new list data');
      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }

  List<ThesaurusModel> searchableList = [];
  String _text = '';

  UnmodifiableListView<ThesaurusModel> get wordList {
    return _text.isEmpty
        ? UnmodifiableListView(datalist)
        : UnmodifiableListView(datalist.where((element) =>
            element.word.toLowerCase().contains(_text.toLowerCase())));
  }

  void changeText(String text) {
    _text = text;
    notifyListeners();
  }
}
