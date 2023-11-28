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
      style: ElevatedButton.styleFrom(
        backgroundColor:
          isSelected ? Colors.brown.withOpacity(0.6) : Colors.white,
        foregroundColor:
          isSelected ? Colors.white : Colors.black,
        shadowColor: Colors.grey,
        textStyle: const TextStyle(fontSize: 20),
        padding: const EdgeInsets.all(12),
        shape: const BeveledRectangleBorder(),
      ),
      child: Text(brandName),
    );
  }
}

