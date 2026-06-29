import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await initialize();

    final iosImplementation = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final result = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return result ?? true;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'campusconnect_notifications',
      'CampusConnect Notifications',
      channelDescription: 'CampusConnect alerts and updates',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      DateTime.now().microsecondsSinceEpoch.remainder(1000000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> clearAll() async {
    await initialize();
    await _plugin.cancelAll();
  }
}
