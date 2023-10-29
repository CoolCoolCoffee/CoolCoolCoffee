import 'package:flutter/material.dart';

class SleepInfoWidget extends StatefulWidget {
  const SleepInfoWidget({Key? key}) : super(key: key);

  @override
  _SleepInfoWidgetState createState() => _SleepInfoWidgetState();
}

class _SleepInfoWidgetState extends State<SleepInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color to brown
      child: Center(
        child: Column(
          children: [
            Text(
              '어제의 수면정보가 맞나요?',
              style: TextStyle(
                fontSize: 15.0,
                  fontWeight: FontWeight.w500 // Set the text color to white
              ),
            ),
            SizedBox(height: 7), // Add space between text and Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusted spacing
              children: [
                Container(
                  width: 165,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown,
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '취침시간',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'AM 1:46',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 165,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown,
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '기상시간',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'AM 7:16',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
