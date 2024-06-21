import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final internetConnectionProvider =
    ChangeNotifierProvider((ref) => InternetConnectionProvider());

class InternetConnectionProvider extends ChangeNotifier {
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  InternetConnectionProvider() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected = result == ConnectivityResult.none;
      notifyListeners();
    });
  }
}
