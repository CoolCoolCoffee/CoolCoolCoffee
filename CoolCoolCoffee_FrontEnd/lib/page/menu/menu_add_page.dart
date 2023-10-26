import 'package:cloud_firestore/cloud_firestore.dart';
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
  //late List<String> sizes;
  //late List<bool> sizeSelected;

  @override
  Widget build(BuildContext context) {

    final _brand = widget.brandName;
    final _menu = widget.menuSnapshot;
    //Map<String,bool> sizeSelected = [true, false, false]
    //sizeSelect(_menu['caffeine_per_size']);
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
        actions: [IconButton(
          onPressed: (){},
          icon: Image.asset('assets/star_unfilled_with_outer.png'),
        ),]
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50,right: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_menu['menu_img'])
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      height: 80,
                      margin: EdgeInsets.only(right: 50,left: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              _brand,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey
                            ),
                          ),
                          Text(
                              _menu.id,
                            style: TextStyle(
                              fontSize: 30
                            ),
                          )],
                      ),
                    ),
                  )
                ],
              ),
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
                  Container(padding: EdgeInsets.all(5),child: Text('사이즈',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                  Row(
                    children: [
                      for(var key in _menu['caffeine_per_size'].keys)
                        Container(
                          padding: EdgeInsets.only(left: 5,right: 5),
                          child: true ? ElevatedButton(onPressed: () {  }, child: Text(key),):OutlinedButton(
                              onPressed: (){
                                /*for(var isSelected in sizeSelected.keys){
                                  if(isSelected==key){
                                    sizeSelected[isSelected] = true;
                                  }else{
                                    sizeSelected[isSelected] = false;
                                  }
                                }*/
                              },
                              child: Text(key)
                          ),
                        )
                    ],
                  )
                ],
              ),
            )
          ),
          Expanded(child: Container(color: Colors.greenAccent,)),
          Expanded(child: Container(color: Colors.blue,))

        ],
      ),
    );
  }

  Map<String,bool>? sizeSelect(Map<String,dynamic> map){
    Map<String,bool>? result;
    for(var key in map.keys){
      result?.addAll({key:false});
    }
    return result;
  }
}

/*
ToggleButtons(
isSelected: sizeSelected,
fillColor: Colors.lightBlue,
selectedColor: Colors.red,
color: Colors.black,
children: <Widget>[
for(var key in _menu['caffeine_per_size'].keys)
Padding(
padding: const EdgeInsets.symmetric(horizontal: 12),
child: Text(key),
),
],
onPressed: (int index){
setState(() {
for (int i = 0; i < sizeSelected.length; i++) {
if (i == index) {
sizeSelected[i] = true;
} else {
sizeSelected[i] = false;
}
}
});
},
),*/
