import 'package:flutter/material.dart';
final modeColor = ModeColor();
class ModeColor{
  Map<String,dynamic> controlModeColor={
    "color_background":Colors.brown.withOpacity(0.6),
    "page_background":Colors.white,
  };
  Map<String,dynamic> noSleepModeColor={
    "color_background":Colors.white,
    "page_background":Colors.brown,
  };
}