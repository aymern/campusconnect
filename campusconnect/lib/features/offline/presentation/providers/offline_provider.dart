import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../data/repositories/offline_cache_repository.dart';
import '../../domain/entities/sync_operation.dart';
import '../../services/connectivity_monitor.dart';
import '../../services/sync_service.dart';

class OfflineProvider extends ChangeNotifier {
  OfflineProvider({
    required OfflineCacheRepository cacheRepository,
    required ConnectivityMonitor connectivityMonitor,
    required SyncService syncService,
  })  : _cacheRepository = cacheRepository,
        _connectivityMonitor = connectivityMonitor,
        _syncService = syncService;

  final OfflineCacheRepository _cacheRepository;
  final ConnectivityMonitor _connectivityMonitor;
  final SyncService _syncService;

  bool _isSyncing = false;
  bool _showOfflineBanner = false;
  List<SyncOperation> _pendingOperations = const [];

  bool get isSyncing => _isSyncing;
  bool get showOfflineBanner => _showOfflineBanner;
  List<SyncOperation> get pendingOperations => List.unmodifiable(_pendingOperations);
  bool get isOnline => _connectivityMonitor.isConnected;

  Future<void> initialize() async {
    await _cacheRepository.initialize();
    _pendingOperations = await _cacheRepository.getPendingOperations();
    _showOfflineBanner = !_connectivityMonitor.isConnected;
    notifyListeners();
  }

  Future<void> syncNow() async {
    if (_isSyncing) {
      return;
    }

    _isSyncing = true;
    notifyListeners();

    try {
      await _syncService.synchronize();
      _pendingOperations = await _cacheRepository.getPendingOperations();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> queuePendingMessage(String payload) async {
    await _syncService.enqueueMessageSync(payload);
    _pendingOperations = await _cacheRepository.getPendingOperations();
    notifyListeners();
  }

  Future<void> queuePendingNotification(String payload) async {
    await _syncService.enqueueNotificationSync(payload);
    _pendingOperations = await _cacheRepository.getPendingOperations();
    notifyListeners();
  }

  void updateOnlineStatus(bool connected) {
    _showOfflineBanner = !connected;
    notifyListeners();
  }

  Future<void> refreshPendingOperations() async {
    _pendingOperations = await _cacheRepository.getPendingOperations();
    notifyListeners();
  }
}
