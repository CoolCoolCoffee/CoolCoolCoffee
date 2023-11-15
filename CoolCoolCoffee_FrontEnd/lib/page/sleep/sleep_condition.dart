import 'package:flutter/material.dart';

class SleepConditionWidget extends StatefulWidget {
  final Function(int conditionLevel) onConditionSelected;

  const SleepConditionWidget({Key? key, required this.onConditionSelected})
      : super(key: key);

  @override
  _SleepConditionWidgetState createState() => _SleepConditionWidgetState();
}

class _SleepConditionWidgetState extends State<SleepConditionWidget> {
  int selectedCondition = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Color(0xFFD0B89E),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            '피곤도를 기록해주세요',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Light brown color
              borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCondition = index + 1;
                    });
                    widget.onConditionSelected(selectedCondition);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(9),
                        width: 55,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedCondition == index + 1
                              ? Colors.brown
                              : Colors.white,
                          border: Border.all(
                            color: Colors.brown,
                            width: 3.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: selectedCondition == index + 1
                                  ? Colors.white
                                  : Colors.brown,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 2),
                      Text(
                        getConditionLevel(index + 1),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Text(
          //   'Sleep Condition: $selectedCondition',
          //   style: TextStyle(fontSize: 16.0),
          // ),
        ],
      ),
    );
  }

  String getConditionLevel(int conditionLevel) {
    switch (conditionLevel) {
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
