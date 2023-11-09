import 'package:flutter/material.dart';

class User {
  String? userName;
  int? userAge;
  TimeOfDay? sleepTime;
  TimeOfDay? wakeTime;
  TimeOfDay? goalSleepTime;
  List<String>? favoriteBrand;

  User({
    this.userName,
    this.userAge,
    this.sleepTime,
    this.wakeTime,
    this.goalSleepTime,
    this.favoriteBrand,
  });

}