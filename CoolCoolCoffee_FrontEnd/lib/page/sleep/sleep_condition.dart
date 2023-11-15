import 'package:flutter/material.dart';

class SleepConditionWidget extends StatefulWidget {
  final Function(int conditionLevel) onConditionSelected;

  const SleepConditionWidget({Key? key, required this.onConditionSelected})
      : super(key: key);

  @override
  _SleepConditionWidgetState createState() => _SleepConditionWidgetState();
}

class _SleepConditionWidgetState extends State<SleepConditionWidget> {
  double selectedCondition = 5.0; // Default value

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '피곤도를 기록해주세요',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  saveSelectedCondition();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                ),
                child: Text('저장'),
              ),
            ],
          ),
          Container(
            width: 350,
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.brown, // Border color
                width: 3.0, // Border width
              ),
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Column(
              children: [
                Slider(
                  value: selectedCondition,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value;
                    });
                    widget.onConditionSelected(selectedCondition.toInt());
                  },
                  activeColor: Colors.brown,
                  inactiveColor: Colors.grey[300],
                  thumbColor: Colors.brown,
                ),
                Text(
                  getConditionLevel(selectedCondition.toInt()),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void saveSelectedCondition() {
    print('!!selectedCondition : $selectedCondition');
    widget.onConditionSelected(selectedCondition.toInt());
  }

  String getConditionLevel(int conditionLevel) {
    return conditionLevel.toString();
  }
}
