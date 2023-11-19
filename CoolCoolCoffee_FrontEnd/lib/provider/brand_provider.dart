import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/brand.dart';

class BrandProvider with ChangeNotifier{
  String brand = '더 벤티';

  void updateBrand (String newBrand){
    brand = newBrand;
    notifyListeners();
  }
}
