
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_img_name_tile.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_toggle_btn.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../model/brand.dart';
import '../../model/user_caffeine.dart';
import '../../page_state/page_state.dart';
import '../../provider/sleep_param_provider.dart';

class MenuAddPageShot extends ConsumerStatefulWidget {
  final DocumentSnapshot brandSnapshot;
  final DocumentSnapshot menuSnapshot;
  final String size;
  final String shot;
  const MenuAddPageShot({super.key, required this.menuSnapshot, required this.brandSnapshot, required this.size, required this.shot,});

  @override
  _MenuAddPageShotState createState() => _MenuAddPageShotState();
}

class _MenuAddPageShotState extends ConsumerState<MenuAddPageShot> {
  //final timeController = TextEditingController();
  DateTime now = DateTime.now();
  num _caffeine = 0;
  String _size = "";
  bool isConfirm = false;
  TextEditingController hoursController = TextEditingController();
  TextEditingController minutesController = TextEditingController();
  FocusNode hoursFocusNode = FocusNode();
  FocusNode minutesFocusNode = FocusNode();
  bool isAM = true;
  _changeSizeCallback(String size, num caffeine) => setState((){
    _size = size;
    _caffeine = caffeine;
  });
  String _shot = "";
  _changeShotCallback(String shot, num caffeine) => setState((){
    if(shot =='샷 추가'){
      if(_shot =='연하게'){
        _caffeine*=2;
      }
      _shot = shot;
      _caffeine += caffeine;
    }
    if(shot=='연하게'){
      if(_shot=='샷 추가'){
        _caffeine+=caffeine;
      }
      _shot = shot;
      _caffeine~/=2;
    }
  });
  late DocumentSnapshot _brand;
  late DocumentSnapshot _menu;
  late List<MapEntry<String,dynamic>> sizeMap;
  late Map<String,dynamic> sortedSize;
  late List<bool> sizeSelected;
  late Map<String,dynamic> shotControl;
  late List<bool> shotSelected;
  late UserCaffeineService userCaffeineService;
  late String today;
  late String time;
  late String todayTime;
  late String yesterday;
  @override
  void initState() {
    super.initState();
    userCaffeineService = UserCaffeineService();
    _size = widget.size;
    _shot = widget.shot;
    _brand = widget.brandSnapshot;
    _menu = widget.menuSnapshot;
    sizeMap = _menu['caffeine_per_size'].entries.toList();
    sizeMap.sort((m1,m2) => m1.value.compareTo(m2.value));
    sortedSize = Map.fromEntries(sizeMap);
    sizeSelected = List<bool>.filled(sortedSize.length, false);
    shotControl = {'연하게':-(_brand['shot']),'샷 추가':_brand['shot']};
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

    DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
    DateFormat timeFormatter = DateFormat('HH:mm');
    today = dayFormatter.format(now);
    time = timeFormatter.format(now);
    yesterday = dayFormatter.format(DateTime.now().subtract(Duration(days:1)));
    todayTime = timeFormatter.format(now);
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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "음료 추가하기",
          style: TextStyle(
              color: Colors.black,
            fontSize: 24
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MenuImgNameTile(brandName: _brand.id,menuSnapshot: _menu, ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, bottom: 10),
                            child: Text('섭취 시간',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                          isConfirm
                              ? Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // 확인 모드에서 분 입력 상태로 전환
                                    isAM = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: isAM
                                      ? Colors.brown.withOpacity(0.6)
                                      : Colors.brown.withOpacity(0.2),
                                  minimumSize: Size(30, 40),
                                ),
                                child: Text('AM'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // 확인 모드에서 분 입력 상태로 전환
                                    isAM = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: !isAM
                                      ? Colors.brown.withOpacity(0.6)
                                      : Colors.brown.withOpacity(0.2),
                                  minimumSize: Size(35, 40),
                                ),
                                child: Text('PM'),
                              ),
                              Container(
                                width: 60,
                                height: 40,
                                child: TextField(
                                  controller: hoursController,
                                  //focusNode: hoursFocusNode,
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
                                  //focusNode: minutesFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: '분',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Container(
                              padding: EdgeInsets.only(left: 5, bottom: 10),
                              child: Text('$time', style: TextStyle(fontSize: 26),)),
                        ],
                      )
                  ),
                ),
                Expanded(
                  flex: 2,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10,top: 30, bottom: 5,),
                      child: ElevatedButton(
                        onPressed: (){
                          //여기!!!!!!!
                          if (isConfirm) {
                            // 확인 모드에서 수정 버튼을 누른 경우
                            int hours = int.parse(hoursController.text);
                            if (!isAM && hours < 12) {
                              hours += 12;
                            }
                            if(!ref.watch(sleepParmaProvider).isToday&&isAM){
                              if(hours==12) hours = 24;
                              else{
                                hours+=24;
                              }
                            }
                            time = '${hours.toString().padLeft(2, '0')}:${minutesController.text}';
                          }
                          isConfirm = !isConfirm;
                          setState(() {});
                        },
                        child: Text(
                          isConfirm? '확인':'수정',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff93796A),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(padding: const EdgeInsets.only(left: 5,bottom: 10),child: const Text('사이즈',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
                      MenuToggleBtn(isSelected: sizeSelected ,map: sortedSize, callback: _changeSizeCallback,),
                    ],
                  )
              ),
            ],
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: const EdgeInsets.only(left: 5,bottom: 10),child: const Text('샷 조절',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
                        MenuToggleBtn(isSelected: shotSelected ,map: shotControl, callback: _changeShotCallback,),
                      ],
                    )
                ),
              ]
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        '카페인 함량',
                        style: TextStyle(
                            fontSize: 12
                        ),
                      ),
                    ),
                    Text('${_caffeine}mg',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5,),
                      child: ElevatedButton(
                        onPressed: (){
                          if(!ref.watch(sleepParmaProvider).isToday) {
                            today = yesterday;
                            if(time == todayTime){
                              int hour = now.hour;
                              int min = now.minute;
                              if (hour == 12)
                                hour = 24;
                              else {
                                hour += 24;
                              }
                              time =
                              '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
                            }
                          }
                          userCaffeineService.addNewUserCaffeine(today, UserCaffeine(drinkTime: time, menuId: _menu.id, brand: _brand.id, menuSize: _size, shotAdded: 0, caffeineContent: _caffeine, menuImg: _menu['menu_img']));
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PageStates(index: 0,)));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff93796A),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        child: const Text(
                          '기록하기',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
