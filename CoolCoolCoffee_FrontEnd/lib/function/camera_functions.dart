import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraFunc{
  Future<Map<String, dynamic>> fetchMenuFromAppCature(RecognizedText recText) async {
    Map<String,dynamic> map= {};
    String brand = "hihi";
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.contains("제조완료된 음료와 푸드는")) {
          brand = "매머드커피";
          map.addAll({"brand":brand});
          await mammothCoffeeMenuCheck(recText).then((value){
            map.addAll(value);
          });
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
    return map;
  }
  Future<Map<String, dynamic>> mammothCoffeeMenuCheck(RecognizedText recText) async {
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("매머드커피").collection("menus");
    bool flag = false;
    bool menu = false;
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text == "S" ||line.text == "M" ||line.text == "L"){
          ret.addAll({"size" : line.text});
          break;
        }
      }
    }
    for(TextBlock block in recText.blocks){
      for(TextLine line in block.lines){
        if(line.text == "결제금액") flag = true;
        if(flag){
          DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(line.text).get();
          if(doc.exists){
            ret.addAll({"document":doc});
            ret.addAll({"success":true});
            menu = true;
            break;
          }
        }
      }
    }
    if(!menu) ret.addAll({"success":false});
    return ret;
  }

  Future<Map<String,dynamic>> fetchMenuFromStarbucksLabel(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    String brand = "스타벅스";
    ret.addAll({"brand":brand});
    bool ice = false;
    bool success = false;
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
    var collection = FirebaseFirestore.instance.collection('Cafe_brand').doc(brand).collection('menus');
    var wait = await FirebaseFirestore.instance
        .collection('Cafe_brand')
        .doc(brand)
        .collection('starbucks_label')
        .get()
        .then((subcol) {
      subcol.docs.forEach((element) {
        if(starbucksMenu[1].trim() == element.id.trim()){
          success = true;
          if(ice){
            menu = element['ice'];
          }else{
            menu = element['hot'];
          }
        }
      });
    });
    if(success){
      DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(menu).get();
      ret.addAll({"document":doc});
      ret.addAll({"size" : size});
    }
    ret.addAll({"success":success});
    return ret;
  }
}