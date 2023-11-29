import 'package:flutter/material.dart';

class LongPopup_A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('LongPopup_A'),
      content: Text('지난 한 주 카페인의 영향을 많이 받으셨나요?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
