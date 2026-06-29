import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../location/domain/repositories/location_repository.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../data/repositories/emergency_repository.dart';

class EmergencyProvider extends ChangeNotifier {
  EmergencyProvider({
    required EmergencyRepository repository,
    required LocationRepository locationRepository,
    required NotificationProvider notificationProvider,
    required bool demoMode,
  })  : _repository = repository,
        _locationRepository = locationRepository,
        _notificationProvider = notificationProvider,
        _demoMode = demoMode;

  final EmergencyRepository _repository;
  final LocationRepository _locationRepository;
  final NotificationProvider _notificationProvider;
  final bool _demoMode;

  List<Map<String, dynamic>> _alertHistory = const [];
  bool _isSending = false;
  String? _activeAlertId;

  List<Map<String, dynamic>> get alertHistory => List.unmodifiable(_alertHistory);
  bool get isSending => _isSending;
  bool get hasActiveAlert => _activeAlertId != null;

  Future<void> initialize() async {
    await _repository.initialize();
    _alertHistory = await _repository.getAlertHistory();
    notifyListeners();
  }

  Future<void> sendEmergencyAlert({required String type, required String message}) async {
    _isSending = true;
    notifyListeners();

    Map<String, dynamic> location;
    if (_demoMode) {
      location = {
        'latitude': 33.4484,
        'longitude': -112.0740,
        'address': 'Demo Campus Location',
        'status': 'demo',
      };
    } else {
      location = await _locationRepository.getCurrentLocation();
    }

    final alert = {
      'id': const Uuid().v4(),
      'type': type,
      'latitude': location['latitude'],
      'longitude': location['longitude'],
      'address': location['address'] ?? 'Unknown location',
      'message': message,
      'created_at': DateTime.now().toIso8601String(),
      'status': 'sent',
    };
    _activeAlertId = alert['id'] as String;
    await _repository.saveAlert(alert);
    _alertHistory = await _repository.getAlertHistory();
    await _notificationProvider.addNotification(
      title: 'Emergency alert sent',
      body: '$type at ${alert['address']}',
      topic: 'emergency',
      payload: alert.toString(),
    );
    _isSending = false;
    notifyListeners();
  }

  Future<void> cancelActiveAlert() async {
    if (_activeAlertId == null) {
      return;
    }
    final alert = {
      'id': _activeAlertId,
      'status': 'cancelled',
      'created_at': DateTime.now().toIso8601String(),
    };
    await _repository.saveAlert(alert);
    _activeAlertId = null;
    _alertHistory = await _repository.getAlertHistory();
    notifyListeners();
  }
}
