import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../Helper/dbHelperIdioms.dart';
import '../Model/britishSlangs.dart';

class BritishSlangsProvider with ChangeNotifier {
  List<BritishSlangs> _britishSlangs = [];
  List<BritishSlangs> _favBritishSlangs = [];
  static String _changeText = '';

  void changeText(String text) {
    _changeText = text;
    notifyListeners();
  }

  Future getBritishSlangsFromdb() async {
    final britishSlangsList =
        await DbHelperIdioms.getBritishSlangsFromDataBase();
    _britishSlangs = britishSlangsList
        .map((e) => BritishSlangs(
            country: e['Country'],
            defination: e['Define'],
            favorite: e['Favorite'],
            id: e['SlangID'],
            slang: e['Slang']))
        .toList();
  }

  UnmodifiableListView<BritishSlangs> get britishSlangsList {
    return _changeText.isEmpty
        ? UnmodifiableListView(_britishSlangs)
        : UnmodifiableListView(_britishSlangs.where((element) =>
            element.slang.toLowerCase().contains(_changeText.toLowerCase())));
  }

  Future updateBritishSlangs(int id, int fav, String slang, String def) async {
    final newSlang = BritishSlangs(
        country: 'British',
        defination: def,
        favorite: fav,
        id: id,
        slang: slang);
    _britishSlangs[_britishSlangs.indexWhere((element) => element.id == id)] =
        newSlang;

    notifyListeners();

    DbHelperIdioms.updateBritishSlangs(
      {'SlangID': id},
      {'Favorite': fav},
    );
  }

  Future getFavoriteBritishSlangsFromModel() async {
    final slangList =
        await DbHelperIdioms.getFavoriteBritishSlangsFromDATABASE();
    _favBritishSlangs = slangList
        .map((e) => BritishSlangs(
            country: e['Country'],
            defination: e['Define'],
            favorite: e['Favorite'],
            id: e['SlangID'],
            slang: e['Slang']))
        .toList();
    notifyListeners();
  }

  UnmodifiableListView<BritishSlangs> get getFavbritishSlangsList {
    return _changeText.isEmpty
        ? UnmodifiableListView(_favBritishSlangs)
        : UnmodifiableListView(_favBritishSlangs.where((element) =>
            element.slang.toLowerCase().contains(_changeText.toLowerCase())));
  }
}
