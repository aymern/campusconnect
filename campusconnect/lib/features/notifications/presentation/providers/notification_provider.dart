<<<<<<< HEAD
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import '../../domain/entities/notification_item.dart';
import '../../services/fcm_service.dart';
import '../../services/local_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider({
    required NotificationRepository repository,
    required FcmService fcmService,
    required LocalNotificationService localNotificationService,
    required bool demoMode,
  })  : _repository = repository,
        _fcmService = fcmService,
        _localNotificationService = localNotificationService,
        _demoMode = demoMode;

  final NotificationRepository _repository;
  final FcmService _fcmService;
  final LocalNotificationService _localNotificationService;
  final bool _demoMode;

  List<AppNotificationItem> _notifications = [];
  bool _isLoading = false;
  bool _permissionGranted = false;
  int _badgeCount = 0;

  List<AppNotificationItem> get notifications => List.unmodifiable(_notifications);
  bool get isLoading => _isLoading;
  bool get permissionGranted => _permissionGranted;
  int get badgeCount => _badgeCount;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _repository.initialize();
    await _localNotificationService.initialize();
    await _fcmService.initialize(
      onMessage: (message) async {
        await handleForegroundMessage(message);
      },
      onBackground: (message) async {
        await handleForegroundMessage(message);
      },
    );

    if (_demoMode) {
      _permissionGranted = true;
    } else {
      _permissionGranted = await _fcmService.requestPermission();
    }

    await _loadHistory();
    _badgeCount = await _repository.unreadCount();

    if (_demoMode && _notifications.isEmpty) {
      await simulateDemoNotification();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    _permissionGranted = await _fcmService.requestPermission();
    if (_permissionGranted) {
      await _localNotificationService.requestPermissions();
    }
    notifyListeners();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcmService.subscribeToTopic(topic);
    await addNotification(
      title: 'Subscribed',
      body: 'You are now subscribed to $topic.',
      topic: topic,
    );
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcmService.unsubscribeFromTopic(topic);
  }

  Future<void> loadHistory() async {
    await _loadHistory();
  }

  Future<void> addNotification({
    required String title,
    required String body,
    String? topic,
    String? payload,
  }) async {
    final notification = NotificationModel(
      id: const Uuid().v4(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      isRead: false,
      topic: topic,
      payload: payload,
    );

    await _repository.saveNotification(notification);
    _notifications.insert(0, notification);
    _badgeCount = await _repository.unreadCount();
    await _localNotificationService.showNotification(
      title: title,
      body: body,
      payload: payload,
    );
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    for (final notification in _notifications) {
      if (notification.id == id) {
        _notifications[_notifications.indexOf(notification)] =
            notification.copyWith(isRead: true);
      }
    }
    _badgeCount = await _repository.unreadCount();
    notifyListeners();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    _notifications = List<AppNotificationItem>.from(
      _notifications.map((notification) => notification.copyWith(isRead: true)),
    );
    _badgeCount = 0;
    notifyListeners();
  }

  Future<void> simulateDemoNotification() async {
    final index = _notifications.length % 3;
    final examples = [
      ('Campus update', 'The library will stay open until 10 PM tonight.'),
      ('Event reminder', 'The campus mixer starts in 30 minutes.'),
      ('Emergency drill', 'A safety drill will begin at 2 PM.'),
    ];
    final (title, body) = examples[index];
    await addNotification(title: title, body: body, topic: 'demo');
  }

  Future<void> handleForegroundMessage(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'] ?? 'CampusConnect';
    final body = message.notification?.body ?? message.data['body'] ?? 'You have a new notification.';
    await addNotification(
      title: title,
      body: body,
      topic: message.from,
      payload: message.data.toString(),
    );
  }

  Future<void> _loadHistory() async {
    final items = await _repository.getHistory();
    _notifications
      ..clear()
      ..addAll(items);
    _badgeCount = await _repository.unreadCount();
=======
import 'package:flutter/foundation.dart';

import '../../domain/entities/campus_notification.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider() {
    _notifications = [
      CampusNotification(
        id: 'notif-1',
        title: 'Campus mixer',
        subtitle: 'Join the student mixer at 6:30 PM.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CampusNotification(
        id: 'notif-2',
        title: 'Library workshop',
        subtitle: 'Resume lab prep starts at 4:00 PM.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: true,
      ),
      CampusNotification(
        id: 'notif-3',
        title: 'Sync reminder',
        subtitle: 'Your offline changes are ready to upload.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ];
  }

  late List<CampusNotification> _notifications;

  List<CampusNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  void markAsRead(String notificationId) {
    _notifications = _notifications
        .map((item) => item.id == notificationId ? item.copyWith(isRead: true) : item)
        .toList(growable: false);
    notifyListeners();
  }

  void addNotification(CampusNotification notification) {
    _notifications = [notification, ..._notifications];
    notifyListeners();
>>>>>>> dc4cda3 (Configure Firebase and complete milestones 8-10)
  }
}
