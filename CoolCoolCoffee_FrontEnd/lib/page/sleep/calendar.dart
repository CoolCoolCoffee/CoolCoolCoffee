import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/service/user_sleep_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Event {
  final DateTime date;
  final int index;
  Event({required this.date, required this.index});
}

class CalendarWidget extends StatefulWidget {
  final Function(DateTime,String?, String?) onDaySelected;

  const CalendarWidget({Key? key, required this.onDaySelected}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, int> dateColors = {};

  String? _sleepTime;
  String? _wakeTime;

  @override
  void initState() {
    super.initState();
    var s = DateTime.utc(2023, 11, 10);
    //print("이거 : $s");
    _updateDateColors();
  }

  Future<void> _updateDateColors() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userSleepCollection = firestore.collection('Users').doc(uid).collection('user_sleep');

    try {
      QuerySnapshot<Map<String, dynamic>> userSleepData = await userSleepCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      userSleepData.docs.forEach((doc) {
        DateTime date = DateTime.parse(doc.id).toLocal();
        if (doc.data()!.containsKey('sleep_quality_score')) {
          int? sleepQualityScore = doc['sleep_quality_score'];

          if (sleepQualityScore != null) {
            DateTime utcDate = DateTime.utc(date.year, date.month, date.day);
            dateColors[utcDate] = sleepQualityScore;
            var c = DateTime(date.year, date.month, date.day);
            //print("tlqkf $c");
          } else {
            print('"sleep_quality_score"가 null: ${doc.id}');
          }
        } else {
          print('"sleep_quality_score": 필드 없음 ${doc.id}');
        }
      });
      setState(() {
        //print("tlqkf11");
      });
    } catch (e) {
      print('Error : $e');
    }
  }

  String convertTo12HourFormat(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    String amPm = (hours >= 12) ? 'PM' : 'AM';

    if (hours > 12) {
      hours -= 12;
    }

    // Pad single-digit minutes with a leading zero
    String formattedMinutes = (minutes < 10) ? '0$minutes' : '$minutes';

    return '$hours:$formattedMinutes $amPm';
  }

  Future<void> _updateSelectedDayInfo(DateTime selectedDay) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userSleepCollection = firestore.collection('Users').doc(uid).collection('user_sleep');

    try {
      _sleepTime = null;
      _wakeTime = null;
      QuerySnapshot<Map<String, dynamic>> userSleepData = await userSleepCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      userSleepData.docs.forEach((doc) {
        DateTime date = DateTime.parse(doc.id).toLocal();

        if (isSameDay(selectedDay, date)) {
          if (doc.data()!.containsKey('sleep_time') && doc.data()!.containsKey('wake_time')) {
            _sleepTime = convertTo12HourFormat(doc['sleep_time']);
            _wakeTime = convertTo12HourFormat(doc['wake_time']);
            print("document 잘 받아옴~");
          } else {
            if (!doc.data()!.containsKey('sleep_time')) {
              _sleepTime = null;
              print('"sleep_time" 필드 없음: ${doc.id}');
            }
            if (!doc.data()!.containsKey('wake_time')) {
              _wakeTime = null;
              print('"wake_time" 필드 없음: ${doc.id}');
            }
          }
        }
      });

      // 업데이트 후에는 UI를 다시 그리기
      setState(() {
        print("tlqkdfdfdf - sleep_time: $_sleepTime, wake_time: $_wakeTime");
      });
    } catch (e) {
      print('Error : $e');
    }
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
          onDaySelected: (selectedDay, focusedDay) async {
            await _updateSelectedDayInfo(selectedDay);
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              widget.onDaySelected(selectedDay, _sleepTime, _wakeTime);// Callback function

              //_updateSelectedDayInfo(selectedDay);
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
