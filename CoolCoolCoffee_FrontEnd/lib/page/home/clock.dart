import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>{

  @override
  Widget build(BuildContext context){
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: Container(
          width: 300,
          height: 300,
          color: Colors.redAccent.withOpacity(0.4),
        ),
      ),
    );
  }
}