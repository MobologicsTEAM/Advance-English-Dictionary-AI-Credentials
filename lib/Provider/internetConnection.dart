import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider extends ChangeNotifier {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  bool _isInternetAvailable = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityProvider() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      print(".................");
      print(result);
    } catch (e) {
      print('Couldn\'t check connectivity status: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    print(">>>>>>>>>>>>");
    _connectionStatus = result; // Storing the result as a list
    print(_connectionStatus);

    // Check if none of the elements are ConnectivityResult.none
    _isInternetAvailable = !result.contains(ConnectivityResult
        .none); // If 'none' is not in the list, internet is available

    print("__________");
    print(
        _isInternetAvailable); // Will be true if internet is available, false if not
    notifyListeners();
  }

  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  bool get isInternetAvailable => _isInternetAvailable;
}
