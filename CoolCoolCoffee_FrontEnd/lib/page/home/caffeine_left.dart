import 'package:flutter/material.dart';

class CaffeineLeftWidget extends StatefulWidget {
  const CaffeineLeftWidget({Key? key}) : super(key: key);

  @override
  _CaffeineLeftWidgetState createState() => _CaffeineLeftWidgetState();
}

class _CaffeineLeftWidgetState extends State<CaffeineLeftWidget> {
  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 350,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}