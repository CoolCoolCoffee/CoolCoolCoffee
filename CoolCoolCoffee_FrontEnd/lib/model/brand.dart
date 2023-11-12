import 'package:flutter/cupertino.dart';

class Brand{
  //우선 icon, label으로 test
  final String id;
  final String logo_image;
  final Map<String,int> size;

  Brand({
    required this.id,
    required this.logo_image,
    required this.size,
  });

  factory Brand.formJson(Map<dynamic,dynamic> json) => Brand(
    id: json['id'],
    logo_image: json['logo_image'],
    size: json['size'],
  );
  Map<String,dynamic> toJson() => {
    "id": id,
    "logo_image": logo_image,
    "size": size,
  };

}

