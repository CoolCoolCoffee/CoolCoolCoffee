import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:coolcoolcoffee_front/provider/star_provider.dart';
import 'package:coolcoolcoffee_front/service/user_favorite_drink_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarIconWithProv extends StatelessWidget {
  final bool isStared;
/*
  final int index;
  final Function callback;

 */
  final UserFavoriteDrink userFavoriteDrink;
  const StarIconWithProv({super.key, required this.isStared, /*required this.callback, required this.index,*/ required this.userFavoriteDrink});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StarProvider(),
      child: IconButton(
        icon: Stack(
            alignment: Alignment.center,
            children: [
              isStared? _filledStarImg():_unfilledStarImg(),
              Image.asset(
                "assets/star_unfilled_with_outer.png",
                width: 20,
                height: 20,
                fit: BoxFit.fill,
              ),
            ]
        ),
        onPressed: (){
          if(isStared){
            UserFavoriteDrinkService().deleteUserFavoriteDrink(userFavoriteDrink);
          }else{
            UserFavoriteDrinkService().addNewUserFavoriteDrink(userFavoriteDrink);
          }
          //Future.delayed(Duration(seconds: 1));
          //callback(!isStared, index);
        },
      ),
    );
  }

  Widget _filledStarImg(){
    return Image.asset(
      "assets/filled_star.png",
      width: 20,
      height: 20,
      fit: BoxFit.fill,
    );
  }
  Widget _unfilledStarImg(){
    return Image.asset(
      "assets/star_unfilled_without_outer.png",
      width: 20,
      height: 20,
      fit: BoxFit.fill,
    );
  }
}
