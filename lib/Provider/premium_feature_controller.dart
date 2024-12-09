import 'package:flutter/foundation.dart';

class PremiumFeatureController extends ChangeNotifier {
  String _selectedPlan = '';

  String get selectedPlan => _selectedPlan;

  void changeSelectedPlan(String id) {
    _selectedPlan = id;
    notifyListeners();
  }
}
