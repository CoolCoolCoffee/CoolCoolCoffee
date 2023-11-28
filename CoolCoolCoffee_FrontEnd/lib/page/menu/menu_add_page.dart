import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_img_name_tile.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_toggle_btn.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/brand.dart';
import '../../model/user_caffeine.dart';

class MenuAddPage extends StatefulWidget {
  final String brandName;
  final DocumentSnapshot menuSnapshot;
  final String size;
  final String shot;
  const MenuAddPage({super.key, required this.menuSnapshot, required this.brandName, required this.size, required this.shot,});

  @override
  State<MenuAddPage> createState() => _MenuAddPageState();
}

class _MenuAddPageState extends State<MenuAddPage> {
  final timeController = TextEditingController();
  num _caffeine = 0;
  String _size = "";
  bool isConfirm = false;
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  bool isAM = true;
  _changeSizeCallback(String size, num caffeine) => setState((){
    _size = size;
    _caffeine = caffeine;
  });
  String _shot = "";
  _changeShotCallback(String shot, num caffeine) => setState((){
    _shot = shot;
    _caffeine += caffeine;
  });
  late String _brand;
  late DocumentSnapshot _menu;
  late List<MapEntry<String,dynamic>> sizeMap;
  late Map<String,dynamic> sortedSize;
  late List<bool> sizeSelected;
  late Map<String,dynamic> shotControl;
  late List<bool> shotSelected;
  late UserCaffeineService userCaffeineService;
  late String today;
  late String time;
  @override
  void initState() {
    super.initState();
    userCaffeineService = UserCaffeineService();
    _size = widget.size;
    _shot = widget.shot;
    _brand = widget.brandName;
    _menu = widget.menuSnapshot;
    sizeMap = _menu['caffeine_per_size'].entries.toList();
    sizeMap.sort((m1,m2) => m1.value.compareTo(m2.value));
    sortedSize = Map.fromEntries(sizeMap);
    sizeSelected = List<bool>.filled(sortedSize.length, false);
    shotControl = {'연하게':-10,'샷 추가':20};
    shotSelected = List<bool>.filled(shotControl.length, false);
    if(_size != ""){
      int i = 0;
      for(var key in sortedSize.keys){
        if(_size == key){
          _caffeine = sortedSize[key];
          sizeSelected[i] = true;
          break;
        }
        i++;
      }
    }
    if(_shot != ""){
      int i = 0;
      for(var key in shotControl.keys){
        if(_shot == key){
          _caffeine += shotControl[key];
          shotSelected[i] = true;
          break;
        }
        i++;
      }
    }
    DateTime now = DateTime.now();
    DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
    DateFormat timeFormatter = DateFormat('HH:mm');
    today = dayFormatter.format(now);
    time = timeFormatter.format(now);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
              Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
            "음료 추가하기",
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MenuImgNameTile(brandName: _brand,menuSnapshot: _menu, ),
          ),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, bottom: 10),
                              child: Text('섭취 시간',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                            isConfirm
                                ? Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 40,
                                      child: TextField(
                                        controller: hoursController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                        labelText: '시',
                                        border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ' : ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Container(
                                      width: 60,
                                      height: 40,
                                      child: TextField(
                                        controller: minutesController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: '분',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isAM = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: isAM
                                            ? Colors.brown.withOpacity(0.6)
                                            : Colors.brown.withOpacity(0.2),
                                        minimumSize: Size(40, 40),
                                      ),
                                      child: Text('AM'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isAM = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: !isAM
                                            ? Colors.brown.withOpacity(0.6)
                                            : Colors.brown.withOpacity(0.2),
                                        minimumSize: Size(40, 40),
                                      ),
                                      child: Text('PM'),
                                    ),
                              ],
                            )
                                : Container(
                                padding: EdgeInsets.only(left: 5, bottom: 10),
                                child: Text('$time')),
                          ],
                        )
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(right: 10,top: 5,bottom: 5,),
                        child: ElevatedButton(
                          onPressed: (){
                            //여기!!!!!!!
                            if (isConfirm) {
                              // 확인 모드에서 수정 버튼을 누른 경우
                              int hours = int.parse(hoursController.text);
                              if (!isAM && hours < 12) {
                                hours += 12;
                              }
                              time = '${hours.toString().padLeft(2, '0')}:${minutesController.text}';
                            }
                            isConfirm = !isConfirm;
                            setState(() {});
                          },
                          child: Text(
                            isConfirm? '확인':'수정',
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        ),
                      )
                  ),
                ],
              ),
          ),
          Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('사이즈',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        MenuToggleBtn(isSelected: sizeSelected ,map: sortedSize, callback: _changeSizeCallback,),
                      ],
                    )
                  ),
                ],
              ),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('샷 조절',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    MenuToggleBtn(isSelected: shotSelected ,map: shotControl, callback: _changeShotCallback,),
                  ],
                )
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '카페인 함량',
                                style: TextStyle(
                                  fontSize: 10
                                ),
                              ),
                              Container(height: 5,),
                              Text(_caffeine.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ) 
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5,),
                          child: ElevatedButton(
                            onPressed: (){
                              userCaffeineService.addNewUserCaffeine(today, UserCaffeine(drinkTime: time, menuId: _menu.id, brand: _brand, menuSize: _size, shotAdded: 0, caffeineContent: _caffeine, menuImg: _menu['menu_img']));
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            child: Text(
                                '기록하기',
                              style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                          ),
                        )
                    )
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
