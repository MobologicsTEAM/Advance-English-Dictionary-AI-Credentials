import 'dart:collection';

import 'package:easy_dictionary_latest/Helper/dbHelperIdioms.dart';
import 'package:flutter/cupertino.dart';

import '../Model/categories.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _categoryList = [];

  String _changeText = '';
  void changeText(String text) {
    _changeText = text;
    notifyListeners();
  }

  UnmodifiableListView<Category> get getCategoryList {
    return _changeText.isEmpty
        ? UnmodifiableListView(_categoryList)
        : UnmodifiableListView(_categoryList.where((element) => element.category
            .toLowerCase()
            .contains(_changeText.toLowerCase())));
  }

  Future getCategoryFromDatabase() async {
    final categoryList = await DbHelperIdioms.getCategoriesFromDb();
    _categoryList = categoryList
        .map(
          (e) => Category(
              category: e['CatName'], catID: e['CatID'], menuID: e['MenuID']),
        )
        .toList();
  }
}
