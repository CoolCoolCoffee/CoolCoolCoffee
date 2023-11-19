import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/star.dart';
import '../service/user_favorite_drink_service.dart';
final starsProvider = StateNotifierProvider<StarProvider,List<Star>>((ref){return StarProvider();});

class StarProvider extends StateNotifier<List<Star>>{
  StarProvider(): super([]);


  void add(Star star){
    if(!isStar(star.id)){
      state = [...state, star];
    }
  }
  void remove(String starId){
    //state = state.where((star) => star != removeStar).toList();
    state = [
      for (final star in state)
        if(star.id != starId) star,
    ];

  }

  bool isStar(String id){
    for(final star in state) {
      if(star.id == id) return true;
    }
    return false;

  }


 /* List<Star> _stars = [];
  UnmodifiableListView<Star> get stars => UnmodifiableListView(_stars);

  void addStar(Star star) {
    _stars.add(star);
    notifyListeners();
  }
  void clickStar(Star star){
    star.clicked();
    notifyListeners();
  }
  void removeStar(Star star){
    _stars.remove(star);
    notifyListeners();
  }
  void clearStars(){
    _stars.clear();
    notifyListeners();
  }*/
}