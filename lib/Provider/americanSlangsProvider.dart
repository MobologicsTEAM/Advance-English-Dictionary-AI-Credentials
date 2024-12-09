import 'dart:collection';

import 'package:easy_dictionary_latest/helper/dbHelperIdioms.dart';
import 'package:flutter/material.dart';

import '../Model/americanSlangsModel.dart';

class AmericanSlangsProvider with ChangeNotifier {
  List<AmericanSlangs> _americanSlangs = [];
  List<AmericanSlangs> _favAmericanSlangs = [];

  static String _changeText = '';

  void changeText(String text) {
    _changeText = text;
    notifyListeners();
  }

  Future getAmericanSlangsFromDb() async {
    final americanSlangs = await DbHelperIdioms.getAmericanSlangsFromDataBase();
    _americanSlangs = americanSlangs
        .map(
          (e) => AmericanSlangs(
            country: e['Country'],
            defination: e['Define'],
            favorite: e['Favorite'],
            etymology: e['Etymology'],
            example: e['Example'],
            synonyms: e['Synonyms'],
            id: e['SlangID'],
            slang: e['Slang'],
          ),
        )
        .toList();
  }

  UnmodifiableListView<AmericanSlangs> get getAmericanSlangs {
    return _changeText.isEmpty
        ? UnmodifiableListView(_americanSlangs)
        : UnmodifiableListView(
            _americanSlangs.where((element) => element.slang
                .toLowerCase()
                .contains(_changeText.toLowerCase())),
          );
  }

  UnmodifiableListView<AmericanSlangs> get getFavAmericanSlangs {
    return _changeText.isEmpty
        ? UnmodifiableListView(_favAmericanSlangs)
        : UnmodifiableListView(
            _favAmericanSlangs.where((element) => element.slang
                .toLowerCase()
                .contains(_changeText.toLowerCase())),
          );
  }

  Future updateAmericanSlangs(String country, String def, int fav, String ety,
      String example, String synonym, int id, String slang) async {
    final newSlang = AmericanSlangs(
        country: country,
        defination: def,
        favorite: fav,
        etymology: ety,
        example: example,
        synonyms: synonym,
        id: id,
        slang: slang);
    _americanSlangs[_americanSlangs.indexWhere((element) => element.id == id)] =
        newSlang;
    notifyListeners();
    DbHelperIdioms.updateAmericanSlangsDb(
      {'SlangID': id},
      {'Favorite': fav},
    );
  }

  Future getAmericanFavoriteSlangsFromdb() async {
    final favAmericanSlangs =
        await DbHelperIdioms.getFavoriteAmericanSlangsFromDATABASE();
    _favAmericanSlangs = favAmericanSlangs
        .map(
          (e) => AmericanSlangs(
            country: e['Country'],
            defination: e['Define'],
            favorite: e['Favorite'],
            etymology: e['Etymology'],
            example: e['Example'],
            synonyms: e['Synonyms'],
            id: e['SlangID'],
            slang: e['Slang'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
