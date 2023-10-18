import 'package:flutter/cupertino.dart';

class Brand{
  //우선 icon, label으로 test
  final String cafe_id;
  final String logo_image;
  final Map<String,int> size;

  Brand({
    required this.cafe_id,
    required this.logo_image,
    required this.size,
  });

  factory Brand.formJson(Map<dynamic,dynamic> json) => Brand(
    cafe_id: json['cafe_id'],
    logo_image: json['logo_image'],
    size: json['size'],
  );
  Map<String,dynamic> toJson() => {
    "cafe_id": cafe_id,
    "logo_image": logo_image,
    "size": size,
  };

}

