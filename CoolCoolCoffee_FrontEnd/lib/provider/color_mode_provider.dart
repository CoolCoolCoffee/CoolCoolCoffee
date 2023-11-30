import 'dart:ui';

import 'package:coolcoolcoffee_front/model/color_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorModeProvider = StateNotifierProvider<ColorModeNotifier,ColorMode>((ref){
  return ColorModeNotifier();
});
class ColorModeNotifier extends StateNotifier<ColorMode>{
  ColorModeNotifier():super(ColorMode(isControlMode: true, selectedIndex: 0));
  void switchMode(int index){
    if(index==0){
      state.isControlMode = true;
    }else{
      state.isControlMode = false;
    }
  }
  void switchIndex(int index){
    state.selectedIndex = index;
  }
}