import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/sleep_param.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user_caffeine.dart';

final sleepParmaProvider = StateNotifierProvider<SleepParamNotifier,SleepParam>((ref){
  return SleepParamNotifier();
});

class SleepParamNotifier extends StateNotifier<SleepParam>{
  SleepParamNotifier():super(SleepParam(isAllSet:false,goal_sleep_time: "", tw: 0, caff_list: [], wake_time: "", sleep_quality: -1,half_time: 5, recommendCaff: 0, isToday: true));
  void setIsAllSet(bool isSet){
    state.isAllSet = isSet;
  }
  void setIsToday(bool isToday){
    state.isToday = isToday;
  }
  void changeRecommendCaff(int caff){
    state.recommendCaff = caff;
  }
  void changeHalfTime(num halfTime){
    state.half_time = halfTime;
  }
  void changeGoalSleepTime(String goal_sleep_time){
    state.goal_sleep_time = goal_sleep_time;
  }
  void changeTw(dynamic tw){
    state.tw = tw;
  }
  void clearCaffList(){
    state.caff_list = [];
  }
  void addCaffList(UserCaffeine userCaffeine){
    if(!caffExists(userCaffeine.drinkTime)){
      state.caff_list = [...state.caff_list, userCaffeine];
    }
  }
  void removeCaffList(UserCaffeine userCaffeine){
    state.caff_list = [
      for(final caff in state.caff_list)
        if(caff.drinkTime != userCaffeine.drinkTime) caff,
    ];
  }
  void changeSleepQuality(int sq){
    state.sleep_quality = sq;
  }
  void changeWakeTime(String wakeTime){
    state.wake_time = wakeTime;
  }
  bool caffExists(String drinkTime){
    for(final caff in state.caff_list){
      if(caff.drinkTime == drinkTime) return true;
    }
    return false;
  }
}