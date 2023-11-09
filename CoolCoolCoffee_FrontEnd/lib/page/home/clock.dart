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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "카페인 섭취 제한 시작까지",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20
          ),
        ),
        // 두 번째 텍스트 표시
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "n시간 m분",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20
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
}