import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserFavoriteDrink{
  String? docID;
  final String menuId;
  final String brand;
  final String menuSize;
  final num shotAdded;
  final num caffeineContent;

  UserFavoriteDrink({
    this.docID,
    required this.menuId,
    required this.brand,
    required this.menuSize,
    required this.shotAdded,
    required this.caffeineContent,
  });

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      'brand':brand,
      'menu_id':menuId,
      'menu_size':menuSize,
      'shot_added':shotAdded,
      'caffeine_content':caffeineContent,
    };
  }

  factory UserFavoriteDrink.fromFireStore(QueryDocumentSnapshot map){
    return UserFavoriteDrink(
        docID: map.id,
        brand:  map['brand'],
        menuId:  map['menu_id'],
        menuSize:  map['menu_size'],
        shotAdded:  map['shot_added'],
        caffeineContent:  map['caffeine_content']
    );
  }

  factory UserFavoriteDrink.fromMap(Map<String,dynamic> map){
    return UserFavoriteDrink(
        docID: map['docID'] != null ? map['docID'] as String : null,
        brand: map['brand'],
        menuId: map['menu_id'],
        menuSize: map['menu_size'],
        shotAdded: map['shot_added'],
        caffeineContent: map['caffeine_content']
    );
  }
  factory UserFavoriteDrink.fromSnaphot(DocumentSnapshot<Map<String,dynamic>> doc){
    return UserFavoriteDrink(
        docID: doc.id,
        brand: doc['brand'],
        menuId: doc['menu_id'],
        menuSize: doc['menu_size'],
        shotAdded: doc['shot_added'],
        caffeineContent: doc['caffeine_content']
    );
  }
}