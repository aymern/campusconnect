import 'package:flutter/foundation.dart';

class OfflineSyncProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _isSyncing = false;
  final List<String> _pendingOperations = <String>[];
  String? _lastSyncedOperation;

  bool get isOnline => _isOnline;
  bool get isSyncing => _isSyncing;
  int get pendingCount => _pendingOperations.length;
  List<String> get pendingOperations => List.unmodifiable(_pendingOperations);
  String? get lastSyncedOperation => _lastSyncedOperation;

  void setOnlineStatus(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  void queueOperation(String operation) {
    _pendingOperations.add(operation);
    notifyListeners();
  }

  Future<void> syncPendingItems() async {
    if (!_isOnline || _pendingOperations.isEmpty) {
      return;
    }

    _isSyncing = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (_pendingOperations.isNotEmpty) {
      _lastSyncedOperation = _pendingOperations.removeLast();
    }

    _isSyncing = false;
    notifyListeners();
  }
}
