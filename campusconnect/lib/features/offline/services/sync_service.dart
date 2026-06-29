import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../data/repositories/offline_cache_repository.dart';
import '../domain/entities/sync_operation.dart';

class SyncService {
  SyncService({required OfflineCacheRepository queueRepository})
      : _queueRepository = queueRepository;

  final OfflineCacheRepository _queueRepository;

  Future<List<SyncOperation>> getPendingOperations() async {
    return _queueRepository.getPendingOperations();
  }

  Future<void> enqueueMessageSync(String payload) async {
    final operation = SyncOperation(
      id: const Uuid().v4(),
      type: 'message',
      payload: payload,
      createdAt: DateTime.now(),
      status: 'pending',
    );
    await _queueRepository.enqueueOperation(operation);
  }

  Future<void> enqueueNotificationSync(String payload) async {
    final operation = SyncOperation(
      id: const Uuid().v4(),
      type: 'notification',
      payload: payload,
      createdAt: DateTime.now(),
      status: 'pending',
    );
    await _queueRepository.enqueueOperation(operation);
  }

  Future<void> retryPendingOperations() async {
    final operations = await _queueRepository.getPendingOperations();
    for (final operation in operations) {
      final updated = operation.copyWith(
        attempts: operation.attempts + 1,
        status: 'syncing',
      );
      await _queueRepository.updateOperation(updated);
      await Future.delayed(const Duration(milliseconds: 300));
      await _queueRepository.updateOperation(
        updated.copyWith(status: 'completed'),
      );
    }
    await _queueRepository.clearCompleted();
  }

  Future<void> synchronize() async {
    await retryPendingOperations();
  }

  String describeStatus(List<SyncOperation> operations) {
    if (operations.isEmpty) {
      return 'Synced';
    }
    return '${operations.length} pending';
  }
}
