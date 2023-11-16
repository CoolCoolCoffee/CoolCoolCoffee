import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserFavoriteDrink{
  final String menuId;
  final String brand;
  final String menuImg;
  //final String menuSize;
  //final num shotAdded;
  //final num caffeineContent;

  UserFavoriteDrink({
    required this.menuId,
    required this.brand,
    required this.menuImg,
    //required this.menuSize,
    //required this.shotAdded,
    //required this.caffeineContent,
  });

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'brand':brand,
      'menu_id':menuId,
      'menu_img':menuImg,
      //'menu_size':menuSize,
      //'shot_added':shotAdded,
      //'caffeine_content':caffeineContent,
    };
  }

  factory UserFavoriteDrink.fromFireStore(QueryDocumentSnapshot map){
    return UserFavoriteDrink(
        brand:  map['brand'],
        menuId:  map['menu_id'],
        menuImg: map['menu_img'],
        //menuSize:  map['menu_size'],
        //shotAdded:  map['shot_added'],
        //caffeineContent:  map['caffeine_content']
    );
  }

  factory UserFavoriteDrink.fromMap(Map<String,dynamic> map){
    return UserFavoriteDrink(
        brand: map['brand'],
        menuId: map['menu_id'],
       menuImg: map['menu_img'],
       // menuSize: map['menu_size'],
        //shotAdded: map['shot_added'],
        //caffeineContent: map['caffeine_content']
    );
  }
  factory UserFavoriteDrink.fromSnaphot(DocumentSnapshot<Map<String,dynamic>> doc){
    return UserFavoriteDrink(
        brand: doc['brand'],
        menuId: doc['menu_id'],
        menuImg: doc['menu_img'],
        //menuSize: doc['menu_size'],
        //shotAdded: doc['shot_added'],
        //caffeineContent: doc['caffeine_content']
    );
  }
}