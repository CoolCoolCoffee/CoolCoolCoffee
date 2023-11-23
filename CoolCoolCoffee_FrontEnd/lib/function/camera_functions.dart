import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraFunc{
  String fetchMenuFromAppCature(RecognizedText recText) {
    String brand = "hihi";
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.contains("제조완료된 음료와 푸드는")) {
          brand = "매머드커피";
          break;
        }
        if (line.text.contains("빽다방")||line.text.contains("백다방")) {
          brand = "빽다방";
          break;
        }
        if (line.text.contains("품질 및 보관 문제로 폐기")) {
          brand = "메가커피";
          break;
        }
        if (line.text.contains("주문 승인 즉시 메뉴 준비")) {
          brand = "스타벅스";
          break;
        }
        if(line.text.contains("이디야커피")){
          brand = "이디야";
          break;
        }
        if(line.text.contains("더벤티")){
          brand = "더벤티";
        }
        if(line.text.contains("투썸오더")||line.text.contains("투쌈페이")){
          brand = "투썸플레이스";
        }
      }
    }
    return brand;
  }
  List<String> mommothCoffeeMenuCheck(RecognizedText recText){
    List<String> ret = [];
    String size = "";
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("S")||line.text.contains("M")||line.text.contains("L")){
          size = line.text;
        }

      }
    }
  }
  Future<List<String>> fetchMenuFromStarbucksLabel(RecognizedText recText) async{
    List<String> ret = [];
    String brand = "스타벅스";
    ret.add(brand);
    bool ice = false;
    String menu = "";
    String korScannedText = "";
    String size = "";
    String shot = "";
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains(RegExp(r'S\)|T\)|G\)|V\)'))) {
          if(line.text.contains(RegExp(r'S\)'))) size = "Short";
          if(line.text.contains(RegExp(r'T\)'))) size = "Tall";
          if(line.text.contains(RegExp(r'G\)'))) size = "Grande";
          if(line.text.contains(RegExp(r'V\)'))) size = "Venti";
          if(line.text.startsWith(RegExp(r'i|I'))) ice =true;
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
            menu = element['ice'];
            ret.add(menu);
          }else{
            menu = element['hot'];
            ret.add(menu);
          }
        }
      });
    });
    ret.add(size);
    ret.add(shot);

    print("menu: $menu");
    print("size: $size");
    print("ice: $ice");
    return ret;
  }

}