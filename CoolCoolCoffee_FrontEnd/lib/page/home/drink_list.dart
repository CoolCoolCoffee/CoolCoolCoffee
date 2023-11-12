import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

import '../menu/menu_page.dart';

class DrinkListWidget extends StatefulWidget {
  const DrinkListWidget({Key? key}) : super(key: key);

  @override
  _DrinkListWidgetState createState() => _DrinkListWidgetState();
}

class _DrinkListWidgetState extends State<DrinkListWidget> {

  String resultText = '';

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Row(
          children: [
            Text(
              "    오늘 000님이 마신 카페인 음료",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
              },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown.withOpacity(0.2),
                  minimumSize: Size(20, 20),
                ),
                child: Text('+')),
          ],
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
            child: Column(
              children: [
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await HealthConnectFactory.installHealthConnect();
                      resultText = 'Install activity started';
                    } catch (e) {
                      resultText = e.toString();
                    }
                    _updateResultText();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('헬스 커넥트 다운'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await HealthConnectFactory.openHealthConnectSettings();
                      resultText = 'Settings activity started';
                    } catch (e) {
                      resultText = e.toString();
                    }
                    _updateResultText();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('설정'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  void _updateResultText() {
    setState(() {});
  }
}