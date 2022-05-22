import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotiManager {
  static final NotiManager _instance = NotiManager._internal();
  static final notifications = FlutterLocalNotificationsPlugin();

  static const notiDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      "pd",
      "Plan Dial Notification",
      priority: Priority.max,
      importance: Importance.max,
    ),
    iOS: IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  factory NotiManager() {
    return _instance;
  }

  NotiManager._internal() {
    _init();
  }

  Future<void> _init() async {
    var androidSetting = const AndroidInitializationSettings('app_icon');

    var iosSetting = const IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSettings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    await notifications.initialize(
      initializationSettings,
      onSelectNotification: null,
    );
  }

  Future<void> addNotification(
      int id, String content, DateTime firstDateTime) async {
    tz.initializeTimeZones();
    var firstTZDateTime = tz.TZDateTime.from(firstDateTime, tz.local);

    notifications.zonedSchedule(
      id,
      "Plan Dial",
      content,
      firstTZDateTime,
      notiDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> removeNotification(int id) async {
    await notifications.cancel(id);
  }

  Future<void> removeAllNotifications() async {
    await notifications.cancelAll();
  }

  Future<void> updateNotification(
      int id, String content, DateTime firstDateTime) async {
    await removeNotification(id);
    await addNotification(id, content, firstDateTime);
  }
}
