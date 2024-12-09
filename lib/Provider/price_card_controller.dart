import 'package:flutter/material.dart';

class PriceCardProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners about the change
  }
}
