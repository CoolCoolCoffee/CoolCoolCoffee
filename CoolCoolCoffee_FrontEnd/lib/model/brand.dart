import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Brand{
  //우선 icon, label으로 test
  late String id;
  late String logo_img;
  //late Map<String,int> size;

  Brand({
    required this.id,
    required this.logo_img,
    //required this.size,
  });

  Brand.fromSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    logo_img = snapshot['logo_img'];
  }
  factory Brand.formJson(Map<dynamic,dynamic> json) => Brand(
    id: json['id'],
    logo_img: json['logo_img'],
    //size: json['size'],
  );
  Map<String,dynamic> toJson() => {
    "id": id,
    "logo_img": logo_img,
    //"size": size,
  };

}

