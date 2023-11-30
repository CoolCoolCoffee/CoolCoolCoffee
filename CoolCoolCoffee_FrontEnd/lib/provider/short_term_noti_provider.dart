import 'package:coolcoolcoffee_front/model/short_term_param.dart';
import 'package:coolcoolcoffee_front/notification/notification_global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final shortTermNotiProvider = StateNotifierProvider<ShortTermNotiNotifier,ShortTermParam>((ref){
  return ShortTermNotiNotifier();
});
class ShortTermNotiNotifier extends StateNotifier<ShortTermParam>{
  ShortTermNotiNotifier():super(ShortTermParam(todayAlarm: false, isCaffTooMuch: false, isCaffOk: false, goal_sleep_time: "", predict_sleep_time: "", isControlMode: true));
  void switchMode(int index){
    if(index==0){
      state.isControlMode = true;
    }else{
      state.isControlMode = false;
    }
    print('여ㅣㄴ shortterm ${state.isControlMode}');
  }
  void setTodayAlarm(){
    state.todayAlarm = true;
  }
  void resetTodayAlarm(){
    state.todayAlarm = false;
  }
  void resetCaffCompare(){
    state.isCaffTooMuch = false;
    state.isCaffOk = false;
  }
  void setGoalSleepTime(String goal_sleep_time){
    state.goal_sleep_time = goal_sleep_time;
  }
  void setPredictSleepTime(String predict_sleep_time){
    state.predict_sleep_time = predict_sleep_time;
  }
  void setCaffCompare(int drinkNum){
    if(state.predict_sleep_time != ""&&state.goal_sleep_time != "") {
      if (!state.isControlMode) {
        bool isAm = false;
        double goal_sleep_time_hour = 0;
        double goal_sleep_time_min = 0;
        double predict_sleep_time_hour = 0;
        double predict_sleep_time_min = 0;
        int hour = 0;
        int minute = 0;
        //goal sleep time 숫자로 변환
        if (state.goal_sleep_time.contains('AM')) {
          isAm = true;
        } else {
          isAm = false;
        }
        var arr = state.goal_sleep_time.split(' ');
        arr = arr[0].split(':');
        goal_sleep_time_hour = double.parse(arr[0]);
        if (isAm) {
          if (goal_sleep_time_hour == 12) goal_sleep_time_hour -= 12;
          goal_sleep_time_hour += 24;
        } else {
          goal_sleep_time_hour += 12;
        }
        goal_sleep_time_min = double.parse(arr[1]) / 60.0;

        if (state.predict_sleep_time.contains('AM')) {
          isAm = true;
        } else {
          isAm = false;
        }
        arr = state.predict_sleep_time.split(' ');
        print('${state.predict_sleep_time}');
        arr = arr[0].split(':');

        predict_sleep_time_hour = double.parse(arr[0]);

        if (isAm) {
          if (predict_sleep_time_hour == 12) predict_sleep_time_hour -= 12;
          predict_sleep_time_hour += 24;
        } else {
          predict_sleep_time_hour += 12;
        }
        predict_sleep_time_min = double.parse(arr[1]) / 60.0;

        print('today Alramr ${state.todayAlarm}');
        print('${goal_sleep_time_hour +
            goal_sleep_time_min} ,, ${predict_sleep_time_hour +
            predict_sleep_time_min})');
        if ((goal_sleep_time_hour + goal_sleep_time_min) >=
            (predict_sleep_time_hour + predict_sleep_time_min)) {
          //short term 2
          print('short term 2');
          if (!state.todayAlarm && !state.isCaffOk) {
            print('set short term 2');
            hour = goal_sleep_time_hour.toInt() - 7;
            minute = (goal_sleep_time_min * 60).toInt();
            print('hour : $hour minute : $minute');

            NotificationGlobal.shortTermFeedBackNoti(
                true,
                false,
                drinkNum,
                hour,
                minute,
                0,
                0);
            state.isCaffOk = true;
            state.isCaffTooMuch = false;
          }
        } else {
          //short term 1
          print('short term 1');
          if (!state.todayAlarm) {
            double delayed_time = (predict_sleep_time_hour +
                predict_sleep_time_min) -
                (goal_sleep_time_hour + goal_sleep_time_min);
            int delayed_hour = delayed_time.toInt();
            int delayed_minutes = ((delayed_time - delayed_hour) * 60).toInt();
            print('delay $delayed_hour : $delayed_minutes');
            DateTime dt = DateTime.now();
            hour = dt.hour;
            minute = dt.minute + 10;
            if (minute >= 60) {
              hour += 1;
              if (hour >= 24) hour -= 24;
              minute -= 60;
            }
            print('set short term 1');
            state.todayAlarm = true;
            print('hour : $hour minute : $minute');
            NotificationGlobal.cancelNotification(2);
            NotificationGlobal.shortTermFeedBackNoti(
                false,
                true,
                drinkNum,
                hour,
                minute,
                delayed_hour,
                delayed_minutes);
            state.isCaffOk = false;
            state.isCaffTooMuch = true;
          }
        }
      }
    }else{
      if(state.isCaffOk||state.isCaffTooMuch){
        NotificationGlobal.cancelNotification(2);
        NotificationGlobal.cancelNotification(3);
      }
    }
  }
}