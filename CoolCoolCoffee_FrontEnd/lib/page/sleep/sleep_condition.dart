import 'package:flutter/material.dart';

class SleepConditionWidget extends StatefulWidget {
  final Function(int fatigueLevel) onFatigueSelected;

  const SleepConditionWidget({Key? key, required this.onFatigueSelected})
      : super(key: key);

  @override
  _SleepConditionWidgetState createState() => _SleepConditionWidgetState();
}

class _SleepConditionWidgetState extends State<SleepConditionWidget> {
  int selectedFatigue = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedFatigue = index + 1;
            });
            widget.onFatigueSelected(selectedFatigue);
          },
          child: Container(
            margin: EdgeInsets.all(8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedFatigue == index + 1
                  ? Colors.blue
                  : Colors.grey,
            ),
            child: Center(
              child: Text(
                (index + 1).toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
