import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserCaffeine{
  String? docID;
  final String drinkTime;
  final String menuId;
  final String brand;
  final String menuImg;
  final String menuSize;
  final num shotAdded;
  final num caffeineContent;

  UserCaffeine({
    this.docID,
    required this.drinkTime,
    required this.menuId,
    required this.brand,
    required this.menuImg,
    required this.menuSize,
    required this.shotAdded,
    required this.caffeineContent,
  });

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'drink_time':drinkTime,
      'menu_id':menuId,
      'brand':brand,
      'menu_img':menuImg,
      'menu_size':menuSize,
      'shot_added':shotAdded,
      'caffeine_content':caffeineContent,
    };
  }

  factory UserCaffeine.fromFireStore(QueryDocumentSnapshot map){
    return UserCaffeine(
      docID: map.id,
      drinkTime: map['drink_time'],
      menuId:  map['menu_id'],
      brand:  map['brand'],
      menuImg: map['menu_img'],
      menuSize:  map['menu_size'],
      shotAdded:  map['shot_added'],
      caffeineContent:  map['caffeine_content']
    );
  }

  factory UserCaffeine.fromMap(Map<String,dynamic> map){
    return UserCaffeine(
        docID: map['docID'] != null ? map['docID'] as String : null,
        drinkTime: map['drink_time'],
        menuId: map['menu_id'],
        brand: map['brand'],
        menuImg: map['menu_img'],
        menuSize: map['menu_size'],
        shotAdded: map['shot_added'],
        caffeineContent: map['caffeine_content']
    );
  }
  factory UserCaffeine.fromSnaphot(DocumentSnapshot<Map<String,dynamic>> doc){
    return UserCaffeine(
        docID: doc.id,
        drinkTime: doc['drink_time'],
        menuId: doc['menu_id'],
        brand: doc['brand'],
        menuImg: doc['menu_img'],
        menuSize: doc['menu_size'],
        shotAdded: doc['shot_added'],
        caffeineContent: doc['caffeine_content']
    );
  }
}