import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calendar.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Page'),
      ),
      body: Column(
        children: [
          CalendarWidget(),
          Expanded(
            child: Container(
              color: Colors.tealAccent,
            ),
          ),
        ],
      ),
    );
  }
}



