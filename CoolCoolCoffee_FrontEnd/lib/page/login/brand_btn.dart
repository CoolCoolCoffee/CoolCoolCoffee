import 'package:flutter/material.dart';

class BrandBtn extends StatelessWidget {
  final String brandName;
  final int pressedNum;
  final bool isSelected;
  final Function(bool) onPressed;

  const BrandBtn({
    Key? key,
    required this.brandName,
    required this.pressedNum,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (pressedNum <= 2) {
          onPressed(!isSelected);
        } else if (pressedNum == 3 && isSelected) {
          onPressed(!isSelected);
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.blue : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.white : Colors.black,
        ),
        shadowColor: MaterialStateProperty.all(Colors.grey),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 20),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      ),
      child: Text(brandName),
    );
  }
}

