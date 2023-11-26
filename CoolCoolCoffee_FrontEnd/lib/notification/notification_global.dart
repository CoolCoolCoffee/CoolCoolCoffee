import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationGlobal {
  static FlutterLocalNotificationsPlugin _localNotification =
  FlutterLocalNotificationsPlugin();

  static initializeNotifications() async {
    AndroidInitializationSettings initSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );
    await _localNotification.initialize(initSettings);
  }

  static showDailyNotification() async {
    const NotificationDetails _details = const NotificationDetails(
      android: AndroidNotificationDetails('daily_notification', 'Daily Notification',channelShowBadge: true,),
    );

    await _localNotification.zonedSchedule(
      1,
      '쿨쿨 커피',
      '오늘의 카페인 다 입력하셨나요?',
      _timeZoneSetting(),
      _details,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _timeZoneSetting() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      _now.year,
      _now.month,
      _now.day,
      10,
      22,
    );
    //tz.TZDateTime scheduledDate = _now.add(const Duration(minutes: 2));
    // if (scheduledDate.isBefore(_now)) {
    //   scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }
    return scheduledDate;
  }

  static cancelNotification(int id) async {
    await _localNotification.cancel(id);
  }

  static cancelAllNotifications() async {
    await _localNotification.cancelAll();
  }
}
