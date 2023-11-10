import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>{

  String sleepEnteredTime = '';
  String wakeEnteredTime = '';

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
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    TextSpan(
                      text: "카페인 섭취 제한 시작까지\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    TextSpan(
                      text: "n시간 m분",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    TextSpan(
                      text: " 남았어요!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isEmpty || wakeEnteredTime.isEmpty)
                    TextSpan(
                      text: "목표 수면 시간을 설정해주세요.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
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
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    Text(
                      '수정',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  if (sleepEnteredTime.isEmpty || wakeEnteredTime.isEmpty)
                    Text(
                      '설정',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                ],
              ),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sleep: $sleepEnteredTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Wake: $wakeEnteredTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


//시간 수정 팝업
  void _showEditPopup(BuildContext context) async {
    TextEditingController sleepHoursController = TextEditingController();
    TextEditingController sleepMinutesController = TextEditingController();
    TextEditingController wakeHoursController = TextEditingController();
    TextEditingController wakeMinutesController = TextEditingController();
    bool sleepIsAM = true;
    bool wakeIsAM = true;

    if (sleepEnteredTime.isNotEmpty) {
      List<String> sleepTimeParts = sleepEnteredTime.split(' ');
      List<String> sleepHourMinute = sleepTimeParts[0].split(':');
      sleepHoursController.text = sleepHourMinute[0];
      sleepMinutesController.text = sleepHourMinute[1];
      sleepIsAM = sleepTimeParts[1] == 'AM';
    }

    if (wakeEnteredTime.isNotEmpty) {
      List<String> wakeTimeParts = wakeEnteredTime.split(' ');
      List<String> wakeHourMinute = wakeTimeParts[0].split(':');
      wakeHoursController.text = wakeHourMinute[0];
      wakeMinutesController.text = wakeHourMinute[1];
      wakeIsAM = wakeTimeParts[1] == 'AM';
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('목표 수면 시간'),
          content: Container(
            constraints: BoxConstraints(maxHeight: 230, maxWidth: 400),
            child: Column(
              children: [
                Text(
                  '취침시간',
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    // Hours TextField
                    Flexible(
                      child: TextField(
                        controller: sleepHoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '시',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Text(
                      ' : ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Flexible(
                      child: TextField(
                        controller: sleepMinutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '분',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sleepIsAM = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown.withOpacity(0.2),
                        minimumSize: Size(40, 30),
                      ),
                      child: Text('AM'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sleepIsAM = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown.withOpacity(0.2),
                        minimumSize: Size(40, 30),
                      ),
                      child: Text('PM'),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  '기상시간',
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    // Hours TextField
                    Flexible(
                      child: TextField(
                        controller: wakeHoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '시',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    // ":" Text
                    Text(
                      ' : ',
                      style: TextStyle(fontSize: 20),
                    ),
                    // Minutes TextField
                    Flexible(
                      child: TextField(
                        controller: wakeMinutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '분',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          wakeIsAM = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown.withOpacity(0.2),
                        minimumSize: Size(40, 30),
                      ),
                      child: Text('AM'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          wakeIsAM = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown.withOpacity(0.2),
                        minimumSize: Size(40, 30),
                      ),
                      child: Text('PM'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String sleepEnteredTime =
                    '${sleepHoursController.text}:${sleepMinutesController.text} ${sleepIsAM ? 'AM' : 'PM'}';
                String wakeEnteredTime =
                    '${wakeHoursController.text}:${wakeMinutesController.text} ${wakeIsAM ? 'AM' : 'PM'}';
                setState(() {
                  this.sleepEnteredTime = sleepEnteredTime;
                  this.wakeEnteredTime = wakeEnteredTime;
                });
                //print('취침 시간 : $sleepEnteredTime');
                //print('기상 시간 : $wakeEnteredTime');
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

}