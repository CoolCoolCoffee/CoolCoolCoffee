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
  @override
  Widget build(BuildContext context) {
    print("addmenu start");
    final _brand = widget.brandName;
    final _menu = widget.menuSnapshot;
    print("${_menu.id} add menu");
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
          Container(height: 20,),
          Expanded(
            flex: 3,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50,right: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                        //border: Border.all(color: Colors.grey,width: 1),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0,5)
                        )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        children: [
                          Container(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                                _brand,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                                _menu.id,
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          )],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(height: 20,),
          Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('사이즈',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    Row(
                      children: [
                        for(var key in _menu['caffeine_per_size'].keys)...[
                          OutlinedButton(
                              onPressed: (){},
                              child: Text(key),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                )
                              )
                          ),
                          Container(width: 10,)
                        ]
                      ],
                    )
                  ],

              )
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
                    Row(
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
                    )
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
                              Text('카페인 함량'),
                              Container(height: 5,),
                              Text(
                                _menu['caffeine_per_size']['Tall'].toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ) 
                    ),
                    Container(width: 10,),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
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
