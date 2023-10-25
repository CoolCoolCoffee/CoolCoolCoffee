import 'package:flutter/material.dart';

class SleepInfoWidget extends StatefulWidget {
  const SleepInfoWidget({Key? key}) : super(key: key);

  @override
  _SleepInfoWidgetState createState() => _SleepInfoWidgetState();
}

class _SleepInfoWidgetState extends State<SleepInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),
            ),
          ),
            // Add any other widgets or content for the first box here
          SizedBox(width: 16), // Adjust the space between the boxes
          Container(
            width: 160,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 3.0,
              ),
            ),
            // Add any other widgets or content for the second box here
          ),
        ],
      ),
    );
  }
}
