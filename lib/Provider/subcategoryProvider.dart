import 'dart:collection';

import 'package:flutter/material.dart';

import '../Helper/dbHelperIdioms.dart';
import '../Model/subCategory.dart';

class SubCategoryProvider with ChangeNotifier {
  List<SubCategory> _subCategoryList = [];
  List<SubCategory> _favSubCategory = [];
  static String _changeText = '';

  void changeText(String text) {
    _changeText = text;

    notifyListeners();
  }

  Future getSubCategoryFromDB(int id) async {
    final subCategoryList =
        await DbHelperIdioms.getDataBasedOnCategoriesFromDB(id);

    _subCategoryList = subCategoryList
        .map(
          (e) => SubCategory(
              define: e['Define'],
              catID: e['CatID'],
              example: e['Ex'],
              fav: e['favorite'],
              idiom: e['Idiom'],
              idiomID: e['iID']),
        )
        .toList();
  }

  UnmodifiableListView<SubCategory> get getSubCategoryIdioms {
    return _changeText.isEmpty
        ? UnmodifiableListView(_subCategoryList)
        : UnmodifiableListView(_subCategoryList.where((element) =>
            element.idiom.toLowerCase().contains(_changeText.toLowerCase())));
  }

  UnmodifiableListView<SubCategory> get getfavSubCategoryIdioms {
    return _changeText.isEmpty
        ? UnmodifiableListView(_favSubCategory)
        : UnmodifiableListView(
            _favSubCategory.where((element) => element.idiom
                .toLowerCase()
                .contains(_changeText.toLowerCase())),
          );
  }

  Future updateSubCategory(
    String def,
    String idiom,
    int iid,
    int fav,
    String example,
    int catID,
  ) async {
    final newSlang = SubCategory(
        define: def,
        catID: catID,
        example: example,
        fav: fav,
        idiom: idiom,
        idiomID: iid);
    _subCategoryList[_subCategoryList.indexWhere((e) => e.idiomID == iid)] =
        newSlang;
    notifyListeners();

    DbHelperIdioms.updateSubCategories({'iID': iid}, {'favorite': fav});
  }

  Future getFavSubCatFromDB(int id) async {
    final subCategoryList = await DbHelperIdioms.getFavSubCategory(id);
    _favSubCategory = subCategoryList
        .map(
          (e) => SubCategory(
              define: e['Define'],
              catID: e['CatID'],
              example: e['Ex'],
              fav: e['favorite'],
              idiom: e['Idiom'],
              idiomID: e['iID']),
        )
        .toList();
  }
}
