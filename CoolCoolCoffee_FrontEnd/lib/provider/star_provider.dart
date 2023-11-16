import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../model/star.dart';

class StarProvider with ChangeNotifier{
  List<Star> _stars = [];
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
  }
}