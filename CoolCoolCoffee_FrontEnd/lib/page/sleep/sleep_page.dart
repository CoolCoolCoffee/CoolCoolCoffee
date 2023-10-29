import 'package:flutter/material.dart';
import 'calendar.dart';
import 'sleep_condition.dart';
import 'sleep_info.dart';
import 'package:coolcoolcoffee_front/health/health_connect.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  int sleepCondition = 1;

  @override
  Widget build(BuildContext context) {
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
        toolbarHeight: 60,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          CalendarWidget(),
          Container(
            //color: Color(0xFFD0B89E),
            color: Colors.white,
            child: Column(
              children: [
                SleepInfoWidget(),
                //SizedBox(height: 30),
                SleepConditionWidget(
                  onConditionSelected: (int sleepLevel) {
                    setState(() {
                      sleepCondition = sleepLevel;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
