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
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(9),
                width: 60,
                height: 70,
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
              Text(
                getFatigueText(index + 1),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String getFatigueText(int fatigueLevel) {
    switch (fatigueLevel) {
      case 1:
        return '매우 피곤';
      case 2:
        return '조금 피곤';
      case 3:
        return '보통';
      case 4:
        return '개운';
      case 5:
        return '매우 개운';
      default:
        return '';
    }
  }
}
