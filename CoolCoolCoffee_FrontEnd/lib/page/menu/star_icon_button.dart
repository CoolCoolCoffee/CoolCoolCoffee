import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarIconButton extends StatelessWidget {
  final bool isStared;
  const StarIconButton({super.key, required this.isStared});

  @override
  Widget build(BuildContext context) {
    print("$isStared");
    return IconButton(
      icon: Stack(
          alignment: Alignment.center,
          children: [
            isStared?
            Image.asset(
              "assets/filled_star.png",
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ):
            Image.asset(
              "assets/star_unfilled_without_outer.png",
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
            Image.asset(
              "assets/star_unfilled_with_outer.png",
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          ]
      ),
      onPressed: (){
      },
    );
  }
}
