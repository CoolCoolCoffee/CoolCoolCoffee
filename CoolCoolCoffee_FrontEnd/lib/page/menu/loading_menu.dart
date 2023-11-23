import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingMenu extends StatelessWidget {
  const LoadingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Column(
                children: [
                  CircularProgressIndicator(backgroundColor: Colors.grey.withOpacity(0.2),),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '메뉴 분석중...',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
          ),
      ),
    );
  }
}
