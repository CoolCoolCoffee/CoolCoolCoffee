import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/service/user_sleep_service.dart';

class Event {
  final DateTime date;
  final int index;
  Event({required this.date, required this.index});
}

class CalendarWidget extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const CalendarWidget({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, int> dateColors = {};

  final UserSleepService _userSleepService = UserSleepService();
  int? _sleepQualityScore;
  String? _sleepTime;
  String? _wakeTime;

  @override
  void initState() {
    super.initState();
    dateColors[DateTime.utc(2023, 11, 10)] = 10;
    dateColors[DateTime.utc(2023, 11, 11)] = 9;
    dateColors[DateTime.utc(2023, 11, 12)] = 8;
    dateColors[DateTime.utc(2023, 11, 13)] = 7;
    dateColors[DateTime.utc(2023, 11, 14)] = 6;
    dateColors[DateTime.utc(2023, 11, 15)] = 5;
    dateColors[DateTime.utc(2023, 11, 16)] = 4;
    dateColors[DateTime.utc(2023, 11, 17)] = 3;
    dateColors[DateTime.utc(2023, 11, 18)] = 2;
    dateColors[DateTime.utc(2023, 11, 19)] = 1;
    dateColors[DateTime.utc(2023, 11, 20)] = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDay == null) {
      _selectedDay = DateTime.now();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 1, 1),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              widget.onDaySelected(selectedDay); // Callback function
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          availableGestures: AvailableGestures.none,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false, // 선택 버튼 숨기기
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (dateColors.containsKey(date)) {
                return Container(
                  width: 35,
                  decoration: BoxDecoration(
                    color: _getColorFromIndex(dateColors[date]!),
                    shape: BoxShape.circle,
                  ),
                );
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   '${_selectedDay!.toLocal().toIso8601String().split('T')[0]}',
              //   style: TextStyle(fontSize: 16),
              // ),
              FutureBuilder<int?>(
                future: _userSleepService.getSleepQualityScore(_selectedDay!.toLocal().toIso8601String().split('T')[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // 로딩 중일 때 표시할 위젯
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    _sleepQualityScore = snapshot.data;
                    //_userSleepService.printAllDocumentIds();
                    //print(_selectedDay!.toLocal().toIso8601String().split('T')[0]);
                    return Container(); // 피곤도를 표시하는 위젯
                  }
                },
              ),
              FutureBuilder<String?>(
                future: _userSleepService.getSleepTime(_selectedDay!.toLocal().toIso8601String().split('T')[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // 로딩 중일 때 표시할 위젯
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    _sleepTime = snapshot.data;
                    //_userSleepService.printAllDocumentIds();
                    //print("sleep time $_sleepTime");
                    return Container(); // 피곤도를 표시하는 위젯
                  }
                },
              ),
              FutureBuilder<String?>(
                future: _userSleepService.getWakeTime(_selectedDay!.toLocal().toIso8601String().split('T')[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // 로딩 중일 때 표시할 위젯
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    _wakeTime = snapshot.data;
                    //_userSleepService.printAllDocumentIds();
                    //print("wake time $_wakeTime");
                    return Container(); // 피곤도를 표시하는 위젯
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorFromIndex(int index) {
    switch (index) {
      case 0:
        return Colors.brown.withOpacity(0.1);
      case 1:
        return Colors.brown.withOpacity(0.17);
      case 2:
        return Colors.brown.withOpacity(0.24);
      case 3:
        return Colors.brown.withOpacity(0.31);
      case 4:
        return Colors.brown.withOpacity(0.38);
      case 5:
        return Colors.brown.withOpacity(0.45);
      case 6:
        return Colors.brown.withOpacity(0.52);
      case 7:
        return Colors.brown.withOpacity(0.59);
      case 8:
        return Colors.brown.withOpacity(0.66);
      case 9:
        return Colors.brown.withOpacity(0.73);
      case 10:
        return Colors.brown.withOpacity(0.8);
      default:
        return Colors.transparent;
    }
  }
}
