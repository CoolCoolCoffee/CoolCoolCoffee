import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>{

  @override
  Widget build(BuildContext context){
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "카페인 섭취 제한 시작까지\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: "n시간 m분",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: " 남았어요!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                  // TextSpan(
                  //   text: "목표 수면 시간을 설정해주세요.",
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 20
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(width: 55),
            ElevatedButton(
              onPressed: () {
                _showEditPopup(context);
              },
              style: ElevatedButton.styleFrom(
                primary: null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit, // 연필 아이콘
                    color: Colors.brown,
                    size: 18,

                  ),
                  SizedBox(width: 3),
                  Text(
                    '수정',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              // child: Text(
              //   '설정',
              //   style: TextStyle(
              //     color: Colors.brown,
              //     fontSize: 17,
              //     decoration: TextDecoration.underline,
              //   ),
              // ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Container(
            width: 250,
            height: 250,
            color: Colors.brown.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  void _showEditPopup(BuildContext context) async {
    TimeOfDay? bedTime = TimeOfDay.now();
    TimeOfDay? wakeUpTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('목표 수면 시간'),
              content: Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: Column(
                  children: [
                    Text('취침 시간'),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: bedTime ?? TimeOfDay.now(),
                        );
                        if (selectedTime != null && selectedTime != bedTime) {
                          setState(() {
                            bedTime = selectedTime;
                          });
                        }
                      },
                      child: Text(bedTime?.format(context) ?? '취침 시간 선택'),
                    ),
                    SizedBox(height: 10),
                    Text('기상 시간'),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: wakeUpTime ?? TimeOfDay.now(),
                        );
                        if (selectedTime != null && selectedTime != wakeUpTime) {
                          setState(() {
                            wakeUpTime = selectedTime;
                          });
                        }
                      },
                      child: Text(wakeUpTime?.format(context) ?? '기상 시간 선택'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('확인'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}