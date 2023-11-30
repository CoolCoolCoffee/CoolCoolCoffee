import 'package:flutter/material.dart';
final modeColor = ModeColor();
class ModeColor{
  Map<String,dynamic> controlModeColor={
    "background_color": const Color(0xffF9F8F7),
    "main_color": const Color(0xff93796A),
    "sub_color": const Color(0xffD4936F),
    "black_color": Colors.black,
    "white_color": Colors.white,
  };
  Map<String,dynamic> noSleepModeColor={
    "background_color": const Color(0xff93796A),
    "main_color": const Color(0xffF9F8F7),
    "sub_color": const Color(0xffD4936F),
    "white_color": Colors.white,
    "black_color": Colors.black,
  };
}