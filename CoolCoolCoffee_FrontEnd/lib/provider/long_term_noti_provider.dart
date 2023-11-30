import 'package:coolcoolcoffee_front/model/long_term_param.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final longTermNotiProvider = StateNotifierProvider<LontTermNotiNotifier,LongTermParam>((ref){
  return LontTermNotiNotifier();
});
class LontTermNotiNotifier extends StateNotifier<LongTermParam>{
  LontTermNotiNotifier():super(LongTermParam(todayDate: '', todayCal: ''));
  void setTodayDate(String today){
    state.todayDate = today;
  }
  void setTodayCal(String calculation){
    state.todayCal = calculation;
  }
}