import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraFunc{
  Future<List<String>> fetchMenuFromStarbucksLabel(RecognizedText recText) async{
    List<String> ret = [];
    String brand = "스타벅스";
    ret.add(brand);
    bool ice = false;
    String menu = "";
    print("fetch start");
    String korScannedText = "";
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains(RegExp(r'S\)|T\)|G\)|V\)'))) {
          korScannedText = korScannedText + line.text + "\n";
        }else if(line.text == 'ice'){
          ice = true;
        }
      }
    }
    final starbucksMenu = korScannedText.split(' ');
    var wait = await FirebaseFirestore.instance
        .collection('Cafe_brand')
        .doc(brand)
        .collection('starbucks_label')
        .get()
        .then((subcol) {
      subcol.docs.forEach((element) {
        if(starbucksMenu[1].trim() == element.id.trim()){
          if(ice){
            menu = element['hot'];
            ret.add(menu);
          }else{
            menu = element['hot'];
            ret.add(menu);
          }
        }
      });
    });
    print("fetch $menu");
    return ret;
  }
}