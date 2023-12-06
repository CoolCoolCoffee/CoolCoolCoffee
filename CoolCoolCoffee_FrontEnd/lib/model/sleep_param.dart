import 'package:coolcoolcoffee_front/model/user_caffeine.dart';

class SleepParam{
  bool isToday;
  bool isAllSet;
  String goal_sleep_time;
  double tw;
  String wake_time;
  int sleep_quality;
  List<UserCaffeine> caff_list;
  num half_time;
  int recommendCaff;
  SleepParam({required this.isAllSet,required this.isToday,required this.goal_sleep_time,required this.tw,required this.caff_list,required this.sleep_quality,required this.wake_time,required this.half_time,required this.recommendCaff});
}