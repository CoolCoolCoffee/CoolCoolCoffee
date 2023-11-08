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
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.brown,
                  width: 3.0,
                ),
              ),
            ),
            Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.brown,
                  width: 3.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}