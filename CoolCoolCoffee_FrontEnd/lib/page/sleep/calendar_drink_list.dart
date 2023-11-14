import 'package:flutter/material.dart';

class CalendarDrinkListWidget extends StatefulWidget {
  final DateTime selectedDay;
  CalendarDrinkListWidget({required this.selectedDay});
  @override
  _CalendarDrinkListWidgetState createState() => _CalendarDrinkListWidgetState();
}

class _CalendarDrinkListWidgetState extends State<CalendarDrinkListWidget> {
  @override
  Widget build(BuildContext context) {
    String selecteddate = widget.selectedDay!.toLocal().toIso8601String().split('T')[0];
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 90,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: Center(
            child: Text(
              '${selecteddate}에 마신 음료',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

