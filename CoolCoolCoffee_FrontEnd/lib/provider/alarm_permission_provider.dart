
import 'package:coolcoolcoffee_front/model/alarm_permission.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alarmPermissionProvider = StateNotifierProvider<AlarmPermissionNotifier,AlarmPermission>((ref){
  return AlarmPermissionNotifier();
});
class AlarmPermissionNotifier extends StateNotifier<AlarmPermission>{
  AlarmPermissionNotifier():super(AlarmPermission(isToday: false, isPermissioned: false));
  void setIsPermissioned(bool isPermissioned){
    state.isPermissioned = isPermissioned;
  }
  void setPermissionDay(bool isToday){
    state.isToday = isToday;
  }
}
