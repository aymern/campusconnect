import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class FcmService {
  Future<void> initialize({
    required void Function(RemoteMessage message) onMessage,
    void Function(RemoteMessage message)? onBackground,
  });

  Future<bool> requestPermission();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}

class FirebaseCloudMessagingService implements FcmService {
  FirebaseCloudMessagingService();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Future<void> initialize({
    required void Function(RemoteMessage message) onMessage,
    void Function(RemoteMessage message)? onBackground,
  }) async {
    await Firebase.initializeApp();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(onMessage);

    if (onBackground != null) {
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    // Background processing is prepared by the notification provider.
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}

class DemoFcmService implements FcmService {
  @override
  Future<void> initialize({
    required void Function(RemoteMessage message) onMessage,
    void Function(RemoteMessage message)? onBackground,
  }) async {
    return;
  }

  @override
  Future<bool> requestPermission() async {
    return true;
  }

  @override
  Future<String?> getToken() async {
    return 'demo-token';
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    return;
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    return;
  }
}
