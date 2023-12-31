import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationGlobal {
  static final NotificationGlobal _instance = NotificationGlobal._();
  factory NotificationGlobal() {
    return _instance;
  }
  // private 생성자
  NotificationGlobal._();

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
  static feverFeedBackNoti(int hour, int minute) async {
    const NotificationDetails _details = NotificationDetails(
      android: AndroidNotificationDetails('fever_notification', 'Fever Notification',channelShowBadge: true,),
    );
    print('효과적인 밤샘 레츠고~~‘');
    await _localNotification.zonedSchedule(
        4,
        '',
    '효과적인 밤샘을 위해 카페인을 섭취해볼까요?',
    _setTimeZoneSetting(hour, minute),
    _details,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
    matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  //short ter id : term 2 -> 2, term 1 -> 3
  static shortTermFeedBackNoti(bool isCaffOk, bool isCaffTooMuch, int caff_length, int hour, int minute, int delayed_hour, int delayed_minutes) async {
    const NotificationDetails _details = NotificationDetails(
      android: AndroidNotificationDetails('short_term_notifiaction', 'Short Term Notification',channelShowBadge: true,),
    );
    //short term 2
    if(isCaffOk){
      print('숏ㅊ텀 2번째 $hour $minute에 보내질 예정');
      await _localNotification.zonedSchedule(
        2,
        '',
        '목표 수면 시간을 맞추기 위해 카페인 조절을 시작해주세요!',
        _setTimeZoneSetting(hour, minute),
        _details,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
    //short term 1
    if(isCaffTooMuch){
      //short term 1 중에 카페인을 마시지 않았을 때
      if(caff_length != 0){
        print('숏텀 1 $hour $minute에 보낼거임 수면 시간 밀렸다잉 카페인 먹어서');
        await _localNotification.zonedSchedule(
          3,
          '',
          //나중에 n시가 계산해서 넣기
          '카페인을 과도하게 섭취하여 취침 시간이 $delayed_hour시간 $delayed_minutes분 밀릴 것으로 예상됩니다. 따듯한 물을 마시거나 운동을 해보는 건 어떨까요?',
          _setTimeZoneSetting(hour, minute),
          _details,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
      else{
        print('숏텀 1 $hour $minute에 카페인은 안 마심');
        await _localNotification.zonedSchedule(
          3,
          '',
          '목표 취침 시간을 맞추기 위해 오늘 하루, 카페인 섭취를 피해볼까요?',
          _setTimeZoneSetting(hour, minute),
          _details,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }

  static showDailyNotification() async {
    const NotificationDetails _details = NotificationDetails(
      android: AndroidNotificationDetails('daily_notification', 'Daily Notification',channelShowBadge: true,),
    );

    await _localNotification.zonedSchedule(
      0,
      '',
      '오늘의 수면 정보 다 입력하셨나요?',
      _setTimeZoneSetting(10,0),
      _details,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await _localNotification.zonedSchedule(
      1,
      '',
      '오늘의 카페인 정보 다 입력하셨나요?',
      _setTimeZoneSetting(16,0),
      _details,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _setTimeZoneSetting(int hour, int minute) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      _now.year,
      _now.month,
      _now.day,
      hour,
      minute,
    );
    return scheduledDate;
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
      12,
      30,
    );
    return scheduledDate;
  }

  static cancelNotification(int id) async {
    print('$id 캔슬함요');
    await _localNotification.cancel(id);
  }

  static cancelAllNotifications() async {
    await _localNotification.cancelAll();
  }

  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
}