import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'sleep_condition.dart';
import 'sleep_info.dart';

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
        title: Text('Sleep Calendar Page'),
      ),
      body: Column(
        children: [
          CalendarWidget(),
          Text('어제의 수면정보가 맞나요?'),
          SleepInfoWidget(),
          SizedBox(height: 30),
          Text('피곤도를 기록해주세요~'),
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



