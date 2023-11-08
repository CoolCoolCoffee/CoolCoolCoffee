import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class SleepInfoWidget extends StatefulWidget {
  const SleepInfoWidget({Key? key}) : super(key: key);

  @override
  _SleepInfoWidgetState createState() => _SleepInfoWidgetState();
}

class _SleepInfoWidgetState extends State<SleepInfoWidget> {
  List<HealthConnectDataType> types = [
    HealthConnectDataType.SleepSession,
  ];
  bool readOnly = true;
  String resultText = '';
  String resultText_start_real = '';
  String resultText_end_real = '';

  String token = "";

  @override
  Widget build(BuildContext context) {
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
                    tz.initializeTimeZones();
                    var startTime = DateTime.now().subtract(const Duration(days: 1));
                    var endTime = DateTime.now();
                    try {
                      final requests = <Future>[];
                      Map<String, dynamic> typePoints = {};
                      for (var type in types) {
                        requests.add(HealthConnectFactory.getRecord(
                          type: type,
                          startTime: startTime,
                          endTime: endTime,
                        ).then((value) => typePoints.addAll({type.name: value})));
                      }
                      await Future.wait(requests);
                      resultText = '$typePoints';

                      var startTimeEpochSecond_start =
                      typePoints['SleepSession']['records'][0]['startTime']['epochSecond'];
                      //resultText_start = startTimeEpochSecond_start.toString();
                      var seoul = getLocation('Asia/Seoul');
                      var resultText_start = TZDateTime.fromMillisecondsSinceEpoch(
                          seoul, startTimeEpochSecond_start * 1000);

                      var startTimeEpochSecond_end =
                      typePoints['SleepSession']['records'][0]['endTime']['epochSecond'];
                      //resultText_end = startTimeEpochSecond_end.toString();
                      var resultText_end = TZDateTime.fromMillisecondsSinceEpoch(
                          seoul, startTimeEpochSecond_end * 1000);

                      var formatter = DateFormat('h:mm a');
                      resultText_start_real = formatter.format(resultText_start);
                      resultText_end_real = formatter.format(resultText_end);
                    } catch (e) {
                      resultText = e.toString();
                    }
                    _updateResultText();
                    print(resultText_start_real);
                    print(resultText_end_real);

                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown, // Change the button color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Change the button border radius here
                    ),
                    elevation: 5, // Change the button elevation (shadow) here
                  ),
                  child: const Text('가져오기'),
                ),
              ],
            ),
            //SizedBox(height: 7),
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
                        resultText_start_real,
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
                        resultText_end_real,
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
          ], // Closing bracket for Column children
        ),
      ),
    );
  }

  void _updateResultText() {
    setState(() {});
  }
}
