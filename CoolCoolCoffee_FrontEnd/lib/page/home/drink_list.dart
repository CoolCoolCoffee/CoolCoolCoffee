import 'package:flutter/material.dart';

class DrinkListWidget extends StatefulWidget {
  const DrinkListWidget({Key? key}) : super(key: key);

  @override
  _DrinkListWidgetState createState() => _DrinkListWidgetState();
}

class _DrinkListWidgetState extends State<DrinkListWidget> {
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Text(
          "오늘 000님이 마신 카페인 음료",
          style: TextStyle(
            fontSize: 20
          ),
        ),
        RichText(
            text : TextSpan(
              children: [
                TextSpan(
                  text: "앞으로 ",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
                TextSpan(
                  text: "150mg ",
                  style: TextStyle(
                      color: Colors.orange
                  ),
                ),
                TextSpan(
                  text: "마실 수 있어요!",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ]
            )
        ),
        SizedBox(height: 7),
        Center(
          child: Container(
            width: 350,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}