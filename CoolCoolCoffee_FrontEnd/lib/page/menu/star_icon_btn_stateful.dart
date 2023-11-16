import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/user_favorite_drink.dart';
import '../../service/user_favorite_drink_service.dart';

class StarIconBtnStateful extends StatefulWidget {
  final bool isStared;
  final int index;
  final Function callback;
  final UserFavoriteDrink userFavoriteDrink;
  const StarIconBtnStateful({super.key, required this.isStared, required this.callback, required this.index, required this.userFavoriteDrink});


  @override
  State<StarIconBtnStateful> createState() => _StarIconBtnStatefulState();
}

class _StarIconBtnStatefulState extends State<StarIconBtnStateful> {
  late bool _isStared;
  late int _index;
  late Function _callback;
  late UserFavoriteDrink _userFavoriteDrink;
  @override
  void initState() {
    _isStared = widget.isStared;
    _index = widget.index;
    _callback = widget.callback;
    _userFavoriteDrink = widget.userFavoriteDrink;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
          alignment: Alignment.center,
          children: [
            _isStared? _filledStarImg():_unfilledStarImg(),
            Image.asset(
              "assets/star_unfilled_with_outer.png",
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            ),
          ]
      ),
      onPressed: (){
        if(_isStared){
          UserFavoriteDrinkService().deleteUserFavoriteDrink(_userFavoriteDrink);
        }else{
          UserFavoriteDrinkService().addNewUserFavoriteDrink(_userFavoriteDrink);
        }
        Future.delayed(Duration(seconds: 1));
        _callback(!_isStared, _index);
        setState(() {

        });
      },
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
