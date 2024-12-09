import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../Helper/dbHelperIdioms.dart';
import '../Model/proverb.dart';

class ProverbProvider with ChangeNotifier {
  List<Proverb> _proverbList = [];
  List<Proverb> _favProverbList = [];
  static String _changeText = '';

  Future updateFavouriteForProverb(
      int id, int favourite, String defination, String proverb1) async {
    final newProverb = Proverb(
      proverb: proverb1,
      defination: defination,
      id: id,
      favourite: favourite,
    );

    _proverbList[_proverbList.indexWhere((element) => element.id == id)] =
        newProverb;
    notifyListeners();
    // if (_favProverbList.isNotEmpty) {
    //   _favProverbList[_favProverbList
    //       .indexWhere((element) => element.id == id)] = newProverb;
    // }
    DbHelperIdioms.updateProverbs({
      'PVID': newProverb.id,
    }, {
      'Favorite': newProverb.favourite,
    });
  }

  UnmodifiableListView<Proverb> get getProverbList => _changeText.isEmpty
      ? UnmodifiableListView(_proverbList)
      : UnmodifiableListView(
          _proverbList.where(
            (element) => element.proverb
                .toLowerCase()
                .contains(_changeText.toLowerCase()),
          ),
        );

  Future getProversFromModel() async {
    final proverbList = await DbHelperIdioms.getProverbsFromDataBase();
    _proverbList = proverbList
        .map(
          (item) => Proverb(
            proverb: item['ProVerb'],
            defination: item['Meanings'],
            id: item['PVID'],
            favourite: item['Favorite'],
          ),
        )
        .toList();
  }

  void changeText(String text) {
    _changeText = text;
    notifyListeners();
  }

  Future getFavProverbsFromModel() async {
    final proverbList = await DbHelperIdioms.getFavProverbsFromDataBase();
    _favProverbList = proverbList
        .map(
          (item) => Proverb(
            proverb: item['ProVerb'],
            defination: item['Meanings'],
            id: item['PVID'],
            favourite: item['Favorite'],
          ),
        )
        .toList();
    notifyListeners();
  }

  UnmodifiableListView<Proverb> get getFavProverbList {
    return _changeText.isEmpty
        ? UnmodifiableListView(_favProverbList)
        : UnmodifiableListView(
            _favProverbList.where(
              (element) => element.proverb
                  .toLowerCase()
                  .contains(_changeText.toLowerCase()),
            ),
          );
  }
}
