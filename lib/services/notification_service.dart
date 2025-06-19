import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  static Future<void> init() async {
    tz.initializeTimeZones();

    final location = tz.getLocation('Asia/Jakarta');
    tz.setLocalLocation(location);

    const android = AndroidInitializationSettings('ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> jadwalNotif({
    required int id,
    required String title,
    required String body,
    required DateTime waktu,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(waktu, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}