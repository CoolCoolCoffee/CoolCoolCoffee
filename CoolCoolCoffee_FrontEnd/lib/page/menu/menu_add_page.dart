import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_img_name_tile.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_toggle_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/brand.dart';

class MenuAddPage extends StatefulWidget {
  final String brandName;
  final DocumentSnapshot menuSnapshot;
  const MenuAddPage({super.key, required this.menuSnapshot, required this.brandName});

  @override
  State<MenuAddPage> createState() => _MenuAddPageState();
}

class _MenuAddPageState extends State<MenuAddPage> {
 /* late String _brand;
  //final _brand = widget.brandName;
  late DocumentSnapshot _menu;
  //final _menu = widget.menuSnapshot;
  late Map<String,dynamic> sortedSize;
  late List<bool> shotSelected;
  // List<MapEntry<String,dynamic>> sizeMap = _menu['caffeine_per_size'].entries.toList();
  // sizeMap.sort((m1,m2) => m1.value.compareTo(m2.value));
  // final Map<String,dynamic> sortedSize = Map.fromEntries(sizeMap);
  // Map<String,bool> sizeSelected = {};
  //final shotSelected = [false, false];

  @override
  void initState(){
    super.initState();
    _brand = widget.brandName;
    _menu = widget.menuSnapshot;
    List<MapEntry<String,dynamic>> sizeMap = _menu['caffeine_per_size'].entries.toList();
    sizeMap.sort((m1,m2) => m1.value.compareTo(m2.value));
    sortedSize = Map.fromEntries(sizeMap);
    shotSelected = [false,false];
  }*/

  @override
  Widget build(BuildContext context) {
    final _brand = widget.brandName;
    final _menu = widget.menuSnapshot;
    List<MapEntry<String,dynamic>> sizeMap = _menu['caffeine_per_size'].entries.toList();
    sizeMap.sort((m1,m2) => m1.value.compareTo(m2.value));
    final sortedSize = Map.fromEntries(sizeMap);
    List<bool> sizeSelected = List<bool>.filled(sortedSize.length, false);
    final shotControl = {'연하게':10,'샷 추가':20};
    final shotSelected = List<bool>.filled(shotControl.length, false);
    /*Map<String,bool>? sizeSelected = {};
    sortedSize.forEach((key, value) {sizeSelected[key] = false;});*/

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
        actions: [
          FractionallySizedBox(
            heightFactor: 0.7,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/star_unfilled_with_outer.png",
                fit: BoxFit.fill,
              ),
            ),
          )
        ]
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MenuImgNameTile(brandName: _brand,menuSnapshot: _menu, ),
          ),
          Expanded(
              child: Column(
                children: [
                  Container(height: 20,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('사이즈',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        MenuToggleBtn(isSelected: sizeSelected ,map: sortedSize,),
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
                    MenuToggleBtn(isSelected: shotSelected ,map: shotControl,),
                    /*Row(
                      children: [
                        OutlinedButton(
                            onPressed: (){},
                            child: Text('연하게'),
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                )
                            )
                        ),
                        Container(width: 10,),
                        OutlinedButton(
                            onPressed: (){},
                            child: Text('샷 추가'),
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                )
                            )
                        ),
                      ],
                    )*/
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
                              Text(
                                _menu['caffeine_per_size']['Tall'].toString(),
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
                            onPressed: (){},
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

  /*List<bool> sizeSelect(Map<String,dynamic> map){
    List<bool> result = [false];
    for(int i=0;i<map.length;i++){
      result.add(false);
    }
    result.removeAt(0);
    return result;
  }*/
}
/*
ToggleButtons(
isSelected: sizeSelected,
onPressed: (int index){
for(int i = 0;i<sizeSelected.length;i++){
if(index==i){
sizeSelected[i] = true;
print('$i ${sizeSelected[i]} ');
}else{
sizeSelected[i] = false;
print('$i ${sizeSelected[i]} ');
}
}
},
children:[
for(var key in _menu['caffeine_per_size'])...[
Padding(
padding: EdgeInsets.symmetric(horizontal: 10),
child: Text(key),
)
]
]
),*/
