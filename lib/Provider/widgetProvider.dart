import 'dart:developer';

import 'package:flutter/cupertino.dart';

class WidgetProvider with ChangeNotifier {
  bool isWriteable = false;
  bool isListening = false;
  bool isLoadingWriting = false;
  int _translateValue = 0;
  String _value = '';
  bool isLoadingListening = false;
  bool _showAd = true;
  bool _isShowingAd = false; // open app ad
  bool _showReviewDialog = true;
  bool _barrierDismissable = false;
  bool _isSearchable = false;
  bool _britishSlangsSearchAble = false;
  bool _americanSlangsSearchAble = false;
  bool _categoriesSearchAble = false;
  bool _subcategoriesSearchAble = false;

  bool get subcategoriesSlangSearchAble {
    return _subcategoriesSearchAble;
  }

  void togglesubCategorySearchAbleToTrue() {
    _subcategoriesSearchAble = true;

    notifyListeners();
  }

  void togglesubCategorySearchAbleToFalse() {
    _subcategoriesSearchAble = false;

    notifyListeners();
  }

  bool get categoriesSlangSearchAble {
    return _categoriesSearchAble;
  }

  void toggleCategorySearchAbleToTrue() {
    _categoriesSearchAble = true;
    notifyListeners();
  }

  void toggleCategorySearchAbleToFalse() {
    _categoriesSearchAble = false;

    notifyListeners();
  }

  bool get americanSlangSearchAble {
    return _americanSlangsSearchAble;
  }

  void toggleAmericanSearchAbleToTrue() {
    _americanSlangsSearchAble = true;

    notifyListeners();
  }

  void toggleAmericanSearchAbleToFalse() {
    _americanSlangsSearchAble = false;

    notifyListeners();
  }

  bool get britishSlangSearchAble {
    return _britishSlangsSearchAble;
  }

  void toggleBritishSearchAbleToTrue() {
    _britishSlangsSearchAble = true;

    notifyListeners();
  }

  void toggleBritishSearchAbleToFalse() {
    _britishSlangsSearchAble = false;

    notifyListeners();
  }

  bool get isSearchAble {
    return _isSearchable;
  }

  bool get showReviewDialog {
    return _showReviewDialog;
  }

  void toggleSearchAbleToTrue() {
    _isSearchable = true;

    notifyListeners();
  }

  void toggleSearchAbleToFalse() {
    _isSearchable = false;

    notifyListeners();
  }

  void toggleReviewDialogToFalse() {
    _showReviewDialog = false;
  }

  bool get barrierDismissable {
    return _barrierDismissable;
  }

  bool get getOpenAppAd {
    return _isShowingAd;
  }

  bool get getShowAd {
    return _showAd;
  }

  int get translateValue {
    return _translateValue;
  }

  String get gettranslatedString {
    return _value;
  }

  void isListenable() {
    isWriteable = !isWriteable;
    notifyListeners();
  }

  void toggleWriting() {
    isLoadingWriting = true;
    notifyListeners();
  }

  void toggleWritingTOFalse() {
    isLoadingWriting = false;
    notifyListeners();
  }

  void toggleTranslateValue(int val) {
    _translateValue = val;
  }

  void setTranslatedString(String text) {
    _value = text;
    notifyListeners();
  }

  void toggleListeningToTrue() {
    isLoadingListening = true;
    notifyListeners();
  }

  void toggleListeningToFalse() {
    isLoadingListening = false;
    notifyListeners();
  }

  void toggleShowAdToFalse() {
    _showAd = false;
    notifyListeners();
  }

  void toggleShowAdToTrue() {
    _showAd = true;
    notifyListeners();
  }

  void toggleOpenAppAdToToogle(bool status) {
    log("****************** openappad is now1 $status *****************************");
    log("****************** openappad is now2 $status *****************************");

    _isShowingAd = status;
    notifyListeners();
  }

  void barrierDismissableToTrue() {
    _barrierDismissable = true;
  }

  void barrierDismissableToFalse() {
    _barrierDismissable = false;
  }
}
