import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityMonitor extends ChangeNotifier {
  ConnectivityMonitor() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final connected = result != ConnectivityResult.none;
      if (connected != _isConnected) {
        _isConnected = connected;
        notifyListeners();
      }
    });
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  Future<void> _initialize() async {
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
