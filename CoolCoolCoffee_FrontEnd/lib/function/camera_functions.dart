import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraFunc{
  Future<Map<String, dynamic>> fetchMenuFromAppCature(RecognizedText recText) async {
    Map<String,dynamic> map= {};
    String brand = "";
    for (TextBlock block in recText.blocks) {
      if(map["success"]!=null){
        break;
      }
      for (TextLine line in block.lines) {
        if (line.text.contains("제조완료된 음료와 푸드는")) {
          brand = "매머드커피";
          await mammothCoffeeMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
        if (line.text.contains("빽다방")||line.text.contains("백다방")) {
          brand = "빽다방";
          await paikCoffeeMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
        if (line.text.contains("품질 및 보관 문제로 폐기")) {
          brand = "메가커피";
          await megaCoffeeMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
        if (line.text.contains("주문 승인 즉시 메뉴 준비")) {
          brand = "스타벅스";
          await starbucksMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
        if(line.text.contains("이디야커피")){
          brand = "이디야";
          await ediyaMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
        if(line.text.contains("더벤티")){
          brand = "더벤티";
          await theVentiMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
        if(line.text.contains("투썸오더")||line.text.contains("투썸페이")){
          brand = "투썸플레이스";
          await twosomeMenuCheck(recText).then((value){map.addAll(value);});
          break;
        }
      }
    }
    if(brand ==""){
      map.addAll({"success":false});
    }
    if(map["success"]){
      map.addAll({"brand":brand});
    }
    return map;
  }

  Future<Map<String, dynamic>> mammothCoffeeMenuCheck(RecognizedText recText) async {
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("매머드커피").collection("menus");
    bool flag = false;
    String size = "";
    String shot = "";
    ret.addAll({"success":false});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text == "S" ||line.text == "M" ||line.text == "L")size = line.text;
        if(line.text.contains("샷 추가"))shot = "샷 추가";
      }
    }
    ret.addAll({"size":size});
    ret.addAll({"shot":shot});
    for(TextBlock block in recText.blocks){
      for(TextLine line in block.lines){
        if(line.text == "결제금액") flag = true;
        if(flag){
          DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(line.text).get();
          if(doc.exists){
            ret.addAll({"document":doc});
            ret["success"] = true;
            break;
          }
        }
      }
    }
    return ret;
  }
  Future<Map<String,dynamic>> paikCoffeeMenuCheck(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("빽다방").collection("menus");
    String menu = "";
    String size = "기본";
    String shot = "";
    ret.addAll({"success":false});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("빽사이즈")||line.text.contains("백사이즈")) size = "빽사이즈";
        if(line.text.contains("샷추가")) shot = "샷 추가";
        if(line.text.contains("연하게")) shot = "연하게";
      }
    }
    ret.addAll({"size":size});
    ret.addAll({"shot":shot});

    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("ICED")){
          var arr = line.text.split("(");
          menu = arr[0] + "(ICED)";
          DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(menu).get();
          if(doc.exists) {
            ret.addAll({"document":doc});
            ret["success"] = true;
            break;
          }
        }
        if(line.text.contains("HOT")){
          var arr = line.text.split("(");
          menu = arr[0] + "(HOT)";
          DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(menu).get();
          if(doc.exists) {
            ret.addAll({"document":doc});
            ret["success"] = true;
            break;
          }
        }
      }
    }
    return ret;
  }
  //mega 아직 안 됨
  Future<Map<String,dynamic>> megaCoffeeMenuCheck(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("메가커피").collection("menus");
    String menu = "";
    String size = "Venti";
    String shot = "";
    bool flag = false;
    bool ice_hot = false;
    ret.addAll({"success":false});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("샷 추가")) shot = "샷 추가";
        if(line.text.contains("연하게")) shot = "연하게";
        if(line.text.contains("CE)")||line.text.contains('HOT')) ice_hot = true;
      }
    }
    ret.addAll({"size":size});
    ret.addAll({"shot":shot});

    if(ice_hot) {
      for (TextBlock block in recText.blocks) {
        if (flag) break;
        for (TextLine line in block.lines) {
          if (line.text.contains("CE)")) {
            var arr = line.text.split(')');
            menu = '(ICE)${arr[1]}';
            DocumentSnapshot<Map<String, dynamic>> doc = await collection.doc(
                menu).get();
            if (doc.exists) {
              flag = true;
              ret.addAll({"document": doc});
              ret["success"] = true;
              break;
            }
          }
          if (line.text.contains('HOT')) {
            menu = line.text;
            DocumentSnapshot<Map<String, dynamic>> doc = await collection.doc(
                menu).get();
            if (doc.exists) {
              flag = true;
              ret.addAll({"document": doc});
              ret["success"] = true;
              break;
            }
          }
        }
      }
    }
    else{
      for (TextBlock block in recText.blocks) {
        for (TextLine line in block.lines) {
          if(line.text.contains("주문번호")) flag = true;
          if(flag){
            DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(line.text).get();
            if(doc.exists){
              ret.addAll({"document":doc});
              ret["success"] = true;
              break;
            }
          }
        }
      }
    }
    return ret;
  }
  Future<Map<String,dynamic>> starbucksMenuCheck(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("스타벅스").collection("menus");
    bool flag = false;
    String size = "";
    bool size_flag = false;
    Map<String,dynamic> shots_per_size = {"Short":1,"Tall":2,"Grande":3,"Venti":4};
    String shot = "";
    ret.addAll({"success":false});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("Iced")||line.text.contains("Hot")){
          var arr = line.text.split("|");
          size = arr[1].trim();
          size_flag = true;
        }
        if(size_flag && line.text.contains("에스프레소 샷")){
          var arr = line.text.split(" ");
          if(arr.length == 3 && int.parse(arr[3]) > shots_per_size[size]) shot = "샷 추가";
          else if(arr.length == 3 && int.parse(arr[3]) < shots_per_size[size]) shot = "연하게";
        }
      }
    }
    ret.addAll({"size":size});
    ret.addAll({"shot":shot});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("주문내역")) flag = true;
        if(flag){
          DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(line.text).get();
          if(doc.exists){
            ret.addAll({"document":doc});
            ret["success"] = true;
            break;
          }
        }
      }
    }

    return ret;
  }
  Future<Map<String,dynamic>> ediyaMenuCheck(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("이디야").collection("menus");
    String menu = "";
    String size = "";
    String shot = "";
    String ice_hot = "";
    ret.addAll({"success":false});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains("ICED")||line.text.contains("HOT")){
          var arr = line.text.split("/");
          ice_hot = arr[0].trim();
          size = arr[1].trim();
        }
        if(line.text.contains("샷 추가")) shot = "샷 추가";
        if(line.text.contains("연하게")) shot = "연하게";
      }
    }
    ret.addAll({"size":size});
    ret.addAll({"shot":shot});
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.replaceAll(RegExp('\\s'), "").contains(RegExp(r"\(?([0-9{1}])?개?\)"))){
          var arr = line.text.split("(");
          print(arr);
          menu = "$ice_hot ${arr[0].trim()}";
          DocumentSnapshot<Map<String,dynamic>> doc = await collection.doc(menu).get();
          if(doc.exists){
            ret.addAll({"document":doc});
            ret["success"] = true;
            break;
          }
        }
      }
    }
    return ret;
  }
  //더벤티 아직 안 됨
  Future<Map<String,dynamic>> theVentiMenuCheck(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("더벤티").collection("menus");
    String menu = "";
    String size = "";
    String shot = "";
    ret.addAll({"success":false});
    return ret;
    for (TextBlock block in recText.blocks) {
      for (TextLine line in block.lines) {

      }
    }
  }
  Future<Map<String,dynamic>> twosomeMenuCheck(RecognizedText recText) async{
    Map<String,dynamic> ret = {};
    var collection = FirebaseFirestore.instance.collection("Cafe_brand").doc("투썸플레이스").collection("menus");
    bool flag = false;
    bool ice = false;
    String menu = "";
    String size = "";
    String shot = "";
    ret.addAll({"success":false});
    for (TextBlock block in recText.blocks) {
      if(flag) break;
      for (TextLine line in block.lines) {
        if(line.text.contains("샷추가")) {
          shot = "샷 추가";
          flag = true;
        }
        if(line.text.contains("연하게")){
          shot = "연하게";
          flag = true;
        }
      }
    }
    ret.addAll({"shot":shot});
    flag = false;

    for (TextBlock block in recText.blocks) {
      if(flag) break;
      for (TextLine line in block.lines) {
        if(line.text.contains(RegExp(r"R$|L$|M$"))) {
          if(line.text.contains("R")) size = "R";
          else if(line.text.contains("L")) size = "L";
          else size = "M";
          ret.addAll({"size":size});

          if(line.text.contains("ice")) ice = true;

          menu = line.text.replaceAll(RegExp(r"[a-zA-Z]"), "");
          if(ice) menu = "아이스$menu";

          await collection.get().then((subcol) {
            subcol.docs.forEach((element){
              if(element.id.replaceAll(' ', '') == menu) {
                ret.addAll({"document":element});
                ret["success"] = true;
              }
            });
          });
          flag = true;
        }
      }
    }
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
    ret.addAll({"size":size});
    ret.addAll({"shot":shot});
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