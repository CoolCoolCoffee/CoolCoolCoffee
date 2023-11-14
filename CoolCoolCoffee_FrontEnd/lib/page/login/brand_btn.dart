import 'package:flutter/material.dart';

class BrandBtn extends StatefulWidget {
  final String brandName;
  final Function(bool) onPressed;
  final int pressedNum;

  const BrandBtn({Key? key, required this.brandName, required this.onPressed, required this.pressedNum}) : super(key: key);

  @override
  State<BrandBtn> createState() => _BrandBtnState();
}

class _BrandBtnState extends State<BrandBtn> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if(widget.pressedNum <=2) {
          setState(() {
            isSelected = !isSelected;
            widget.onPressed(isSelected);
          });
        }
        else if(widget.pressedNum == 3){
          if(isSelected == true) {
            setState(() {
              isSelected = !isSelected;
              widget.onPressed(isSelected);
            });
          }
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.blue : Colors.white,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          isSelected? Colors.white : Colors.black,
        ),
        shadowColor: MaterialStateProperty.all(Colors.grey),
        // 3d 입체감 효과
        // elevation: MaterialStateProperty.all(5),
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
        // 테두리는 side
      ),
      child: Text(widget.brandName),
    );
  }
}