import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'sleep_condition.dart';

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
        title: Text('Sleep Page'),
      ),
      body: Column(
        children: [
          CalendarWidget(),
          // 추가: SleepConditionWidget
          Expanded(
            child: Container(
              color: Colors.tealAccent,
            ),
          ),
          SleepConditionWidget(
            onFatigueSelected: (int sleepLevel) {
              setState(() {
                sleepCondition = sleepLevel;
              });
            },
          ),

          // 선택된 피곤도 표시
          Text('Sleep Condition: $sleepCondition'),

        ],
      ),
    );
  }
}



