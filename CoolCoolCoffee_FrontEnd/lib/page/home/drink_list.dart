import 'package:flutter/material.dart';

class DrinkListWidget extends StatefulWidget {
  const DrinkListWidget({Key? key}) : super(key: key);

  @override
  _DrinkListWidgetState createState() => _DrinkListWidgetState();
}

class _DrinkListWidgetState extends State<DrinkListWidget> {
  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: Container(
          width: 350,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.brown,
              width: 3.0,
            ),
          ),
        ),
      ),
    );
  }
}