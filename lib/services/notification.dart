import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rhythmcare/components/repeat.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Notification {
  static Future<void> scheduleNotification(
      Repeat repeat, TimeOfDay time) async {
    switch (repeat) {
      case Repeat.once:
        await scheduleOneNotification(time);
        return;
      case Repeat.day:
        await scheduleDailyNotification(time);
        return;
      default:
        await scheduleWeeklyNotification(time, repeat);
        return;
    }
  }

  static Future<void> scheduleOneNotification(TimeOfDay time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'rhythmcare',
      'Make a record now!',
      _nextInstanceOfTime(time),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'Notification channel id',
          'Notification',
          '',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('goes_without_saying_608'),
          playSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'once',
    );
  }

  static Future<void> scheduleDailyNotification(TimeOfDay time) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'rhythmcare',
        'Make a daily record now!',
        _nextInstanceOfTime(time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Daily notification channel id',
            'Daily notification',
            '',
            importance: Importance.high,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('goes_without_saying_608'),
            playSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> scheduleWeeklyNotification(TimeOfDay time, Repeat repeat) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'rhythmcare',
        'Make a weekly record now!',
        _nextInstanceOfTimeWeekly(time, repeat),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'Weekly notification channel id',
            'Weekly notification',
            '',
            importance: Importance.high,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('goes_without_saying_608'),
            playSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfTimeWeekly(TimeOfDay time, Repeat repeat) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
    while (scheduledDate.weekday != RepeatString.repeatToDateTime(repeat)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<int> checkPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests.length;
  }
}
