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
            Expanded(
              child: Text(
                "카페인 섭취 제한 시작까지",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(width: 0), // Adjust the width as needed
            ElevatedButton(
              onPressed: () {
                _showEditPopup(context); // Show the edit popup
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown, // 버튼의 배경색
                //minimumSize: Size(5, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5, // 그림자 효과
              ),
              child: Text('수정'),
            ),
          ],
        ),
        // 두 번째 텍스트 표시
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            children: [
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
            ],
          ),
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

  void _showEditPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('목표 수면 시간'),
          content: Container(
            constraints: BoxConstraints(maxHeight: 200), // Set maximum height
            child: Column(
              children: [
                Text('취침 시간'),
                TextField(
                  decoration: InputDecoration(labelText: '취침 시간'),
                ),
                Text('기상 시간'),
                TextField(
                  decoration: InputDecoration(labelText: '기상 시간'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}