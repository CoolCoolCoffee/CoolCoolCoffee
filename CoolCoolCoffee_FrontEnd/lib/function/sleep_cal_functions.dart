import 'dart:math';

import '../model/user_caffeine.dart';

class SleepCalFunc{
  int calRecommend(double sleep_graph, double high_graph, double now, double goal_sleep_time,num half_time){
    double scaling = 0.0012;
    double recommendCaff = 0;
    double abstract = (sleep_graph - high_graph)/100;
    double time_left = goal_sleep_time - now - 1;
    //공식 : abstract = scaling * (x) * pow(0.5,(time_left/half_time))
    recommendCaff = abstract * pow(2, (time_left/half_time.toDouble()))* 833.33333;
    int ret = 0;
    int remain = recommendCaff.toInt() % 10;
    if(remain == 0){
      ret = recommendCaff.toInt();
    }else{
      ret = (recommendCaff.toInt()~/10)+1;
      ret*=10;
    }
    print('returen caffeine $ret');
    return ret;
  }
  double calCaff(double caffeine, double eat_time,double now,double half_time){
    double scaling = 0.0012;
    double scaled_caff = caffeine *scaling;
    double ret = 0;
    if(now<eat_time) return ret;
    if(now>=eat_time && now<=(eat_time + 1)) {
      ret = (scaled_caff)*(now-eat_time);
    } else {
      ret = scaled_caff * pow(0.5,((now - eat_time)/half_time));
    }
    return ret;
  }
  double formatTime(String time){
    bool isAM;
    if(time.contains('AM')) isAM= true;
    else isAM = false;
    var split = time.split(' ');
    var timeComponents = split[0].split(':');
    double hour = double.parse(timeComponents[0]);
    double min = double.parse(timeComponents[1])/60.0;
    double ret = double.parse((hour + min).toStringAsFixed(8));
    return ret;
  }
  Map<double,double> formatCaff(List<UserCaffeine> caff_list){
    Map<double,double> ret = {};
    for(int i = 0;i<caff_list.length;i++){
      var timeCompo = caff_list[i].drinkTime.split(':');
      double hour = double.parse(timeCompo[0]);
      double min = double.parse(timeCompo[1])/60.0;
      double drinkTime = double.parse((hour + min).toStringAsFixed(8));
      num caff = caff_list[i].caffeineContent;
      ret.addAll({drinkTime: caff.toDouble()});
    }
    return ret;
  }
  double timeMap(double t) {
    double C = 0.45145833333;
    //if(t>24) t = t-24;
    if(t>10.835) t= t/24-C;
    else t=(t+24)/24 -C;
    return t;
  }
  String setPredictedBedTime(double t){
    String ret = '';
    double step = 0.1666666;
    int hour = 0;
    double min_temp = t - t.toInt();
    //print('t : $t ${t.toInt().toDouble()} min : ${25.3333332 - 25.0}');
    int minute = 0;
    bool isAm = true;
    if(t>24) {
      t -= 24;
    }
    if(t>12) {
      if(t.toInt() == 24){
        isAm = true;
      }else{
        isAm = false;
      }
      t -= 12;
    }
    hour = t.toInt();
    //print('$min_temp $step ${min_temp/step}');
    minute = 10 * (min_temp/step).ceil();
    if(minute == 0){
      ret = '$hour:00 ${isAm?'AM':'PM'}';
    }else{
      ret = '$hour:$minute ${isAm?'AM':'PM'}';
    }
    return ret;
  }
}