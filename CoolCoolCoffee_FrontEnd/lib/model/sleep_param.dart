import 'package:coolcoolcoffee_front/model/user_caffeine.dart';

class SleepParam{
  String goal_sleep_time;
  dynamic tw;
  String wake_time;
  List<UserCaffeine> caff_list;
  SleepParam({required this.goal_sleep_time,required this.tw,required this.caff_list,required this.wake_time});
}