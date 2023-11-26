import 'package:coolcoolcoffee_front/page/sleep/calendar_drink_list.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calendar.dart';
import 'sleep_condition.dart';
import 'sleep_info.dart';
import 'package:coolcoolcoffee_front/service/user_sleep_service.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final UserSleepService _userSleepService = UserSleepService();
  int sleepCondition = 1;
  DateTime? selectedDay;
  String? _sleepTime;
  String? _wakeTime;
  DateTime today = DateTime.now();


  @override
  Widget build(BuildContext context) {
    if (selectedDay == null) {
      selectedDay = DateTime.now();
    }
    print(today);
    String selecteddate = selectedDay!.toLocal().toIso8601String().split(
        'T')[0];
    String todaydate = today.toLocal().toIso8601String().split('T')[0];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '수면 기록',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 50,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CalendarWidget(
              onDaySelected: (DateTime selectedDay, String? sleepTime, String? wakeTime) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this._sleepTime = sleepTime;
                  this._wakeTime = wakeTime;
                  print("tlqkf11 - sleep_time: $_sleepTime, wake_time: $_wakeTime");
                });
              },
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SleepInfoWidget(
                    selectedDay: selectedDay!,
                    sleepTime: _sleepTime,
                    wakeTime: _wakeTime,
                  ),
                  SizedBox(height: 10),
                  if (selecteddate == todaydate)
                    SleepConditionWidget(
                      onConditionSelected: (int sleepLevel) {
                        setState(() {
                          sleepCondition = sleepLevel;
                        });
                      },
                    )
                  else
                    CalendarDrinkListWidget(
                      selectedDay: selectedDay!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}