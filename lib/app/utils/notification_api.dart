import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future cancelNotification(int id) => _notification.cancel(id);
  static Future cancelAllNotification() => _notification.cancelAll();
  static Future cancelNotificationByTag(String tag) =>
      _notification.cancel(0, tag: tag);
      
  static Future init({
    bool initScheduled = false,
  }) async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _notification.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        print('notification payload: $payload');
      },
    );
  }

  static Future showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) =>
      _notification.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
        ),
        payload: payload,
      );

  static Future scheduledNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required Time scheduledDate,
  }) async {
    print("enter scheduledNotification");
    await _notification.zonedSchedule(
      id,
      title,
      body,
      _scheduledDaily(scheduledDate),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print("finished scheduledNotification");
  }

  static tz.TZDateTime _scheduledDaily(Time time) {
    print("enter _scheduledDaily");
    final jakarta = tz.getLocation('Asia/Jakarta');
    tz.setLocalLocation(jakarta);
    final now = tz.TZDateTime.now(jakarta);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, time.hour, time.minute, time.second);
    print("before return _scheduledDaily");

    return scheduledDate.isBefore(now)
        ? scheduledDate = scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }
}