// sleep_info.dart
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:coolcoolcoffee_front/service/user_sleep_service.dart';

class SleepInfoWidget extends StatefulWidget {
  final DateTime selectedDay;
  final String? sleepTime;
  final String? wakeTime;
  const SleepInfoWidget({Key? key, required this.selectedDay,this.sleepTime, this.wakeTime,}) : super(key: key);

  @override
  _SleepInfoWidgetState createState() => _SleepInfoWidgetState();
}

class _SleepInfoWidgetState extends State<SleepInfoWidget> {
  final UserSleepService _userSleepService = UserSleepService();
  String resultText_start_real = '';
  String resultText_end_real = '';
  DateTime today = DateTime.now();
  String selecteddate = '';
  String todaydate = '';

  List<HealthConnectDataType> types = [HealthConnectDataType.SleepSession];

  @override
  Widget build(BuildContext context) {
    String selecteddate = widget.selectedDay!.toLocal().toIso8601String().split('T')[0];
    String todaydate = today.toLocal().toIso8601String().split('T')[0];
    print('Selected Day: ${widget.selectedDay}');
    print('SleepTime in initState: ${widget.sleepTime}');
    print('Wake in initState: ${widget.wakeTime}');
    print('selecteddate $selecteddate');
    print('todaydate $todaydate');
    // resultText_start_real = widget.sleepTime ?? '';
    // resultText_end_real = widget.wakeTime ?? '';
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '어제의 수면정보가 맞나요?',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    //_fetchSleepTimeAndUpdateState();
                    tz.initializeTimeZones();
                    var startTime = widget.selectedDay.subtract(const Duration(days: 1));
                    var endTime = widget.selectedDay;
                    try {
                      final requests = <Future>[];
                      Map<String, dynamic> typePoints = {};
                      for (var type in types) {
                        requests.add(
                          HealthConnectFactory.getRecord(
                            type: type,
                            startTime: startTime,
                            endTime: endTime,
                          ).then(
                                (value) => typePoints.addAll({type.name: value}),
                          ),
                        );
                      }
                      await Future.wait(requests);
                      final resultText = '$typePoints';

                      final startTimeEpochSecond_start =
                      typePoints['SleepSession']['records'][0]['startTime']['epochSecond'];
                      final seoul = getLocation('Asia/Seoul');
                      final resultText_start = TZDateTime.fromMillisecondsSinceEpoch(
                        seoul,
                        startTimeEpochSecond_start * 1000,
                      );

                      final startTimeEpochSecond_end =
                      typePoints['SleepSession']['records'][0]['endTime']['epochSecond'];
                      final resultText_end = TZDateTime.fromMillisecondsSinceEpoch(
                        seoul,
                        startTimeEpochSecond_end * 1000,
                      );

                      final formatter = DateFormat('h:mm a');
                      resultText_start_real = formatter.format(resultText_start);
                      resultText_end_real = formatter.format(resultText_end);
                    } catch (e) {
                      print(e.toString());
                    }
                    _updateResultText();
                    print(resultText_start_real);
                    print(resultText_end_real);

                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text('가져오기'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 165,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown,
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '취침시간',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        selecteddate == todaydate ? resultText_start_real : widget.sleepTime ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 165,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown,
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '기상시간',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        selecteddate == todaydate ? resultText_end_real : widget.wakeTime ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateResultText() {
    setState(() {});
  }
}
