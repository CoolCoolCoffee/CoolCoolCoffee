import 'dart:io';import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart';import 'package:image_picker/image_picker.dart';class GeneralMenuAddPage extends StatefulWidget {  const GeneralMenuAddPage({super.key});  @override  State<GeneralMenuAddPage> createState() => _GeneralMenuAddPageState();}class _GeneralMenuAddPageState extends State<GeneralMenuAddPage> {  final brandController = TextEditingController();  String brand = "";  XFile? _image; //이미지를 담을 변수 선언  final ImagePicker picker = ImagePicker();  bool imageUpload = false;  @override  void initState() {    super.initState();  }  @override  Widget build(BuildContext context) {    return Scaffold(      appBar: AppBar(        leading: IconButton(          icon: Icon(Icons.arrow_back),          onPressed: (){            Navigator.pop(context);          },        ),        title: Text('음료 추가하기'),      ),      body: Column(        children: [          Expanded(              flex: 3,              child: Container(                padding: EdgeInsets.only(top: 20,bottom: 10),                child: Stack(                  children: [                    GestureDetector(                      child: Container(                        margin: EdgeInsets.only(left: 50,right: 50),                        decoration: !imageUpload?                        BoxDecoration(                            borderRadius: BorderRadius.circular(20),                          color: Colors.grey[300],                        ):                        BoxDecoration(                          borderRadius: BorderRadius.circular(20),                          image: DecorationImage(                            fit: BoxFit.fill,                            image: FileImage(File(_image!.path)),                          ),                          color: Colors.blue,                        ),                        child: !imageUpload ?                        Center(                          child: Container(                            margin: EdgeInsets.only(top:80),                            child: Column(                              children: [                                Text('눌러서 메뉴 사진을 업로드하세요!'),                                Icon(Icons.camera_alt_outlined)                              ],                            ),                          ),                        ):                        Center(                          child: Container(                            margin: EdgeInsets.only(top:80),                          ),                        ),                      ),                      onTap: (){                        _dialogBuilder(context);                      },                    ),                    Align(                      alignment: Alignment.bottomCenter,                      child: Container(                        alignment: Alignment.bottomLeft,                        height: 80,                        margin: EdgeInsets.only(right: 50,left: 50),                        decoration: BoxDecoration(                          //border: Border.all(color: Colors.grey,width: 1),                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),                            color: Colors.white,                            boxShadow: [BoxShadow(                                color: Colors.grey.withOpacity(0.7),                                spreadRadius: 0,                                blurRadius: 5.0,                                offset: Offset(0,5)                            )]                        ),                        child: Column(                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,                          crossAxisAlignment: CrossAxisAlignment.start ,                          children: [                            Container(height: 5,),                            Padding(                              padding: const EdgeInsets.only(left: 8.0),                              child: Text(                                '$brand',                                style: TextStyle(                                    fontSize: 15,                                    color: Colors.grey                                ),                              ),                            ),                            Padding(                              padding: const EdgeInsets.only(left: 8.0),                              child: Text(                                'menu',                                style: TextStyle(                                    fontSize: 20                                ),                              ),                            )],                        ),                      ),                    )                  ],                ),              ),          ),          Expanded(              child: Row(                children: [                  Container(margin: EdgeInsets.only(left: 10,right: 10),child: Text('섭취시간',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),                ],              )          ),          Expanded(            child: Row(              children: [                Container(margin: EdgeInsets.only(left: 10,right: 10),child: Text('브랜드',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),                Flexible(                  child:                  TextField(                    controller: brandController,                    onSubmitted: (text){brand = text;},                    decoration: InputDecoration(                      border: OutlineInputBorder(),                      constraints: BoxConstraints(                        maxHeight: 40                      )                    ),                  ),                ),                Container(                  margin: EdgeInsets.only(left: 10,right: 10),                  width: 80,                  child: ElevatedButton(                    child: Text('입력'),                    onPressed: (){                      setState(() {                        brand = brandController.text;                      });                    },                  ),                )              ],            )//            Container(child: Text('menu'),color: Colors.green,),          ),          Expanded(              child: Row(                children: [                  Container(margin: EdgeInsets.only(left: 10,right: 10),child: Text('메뉴',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),                  Flexible(                    child:                    TextField(                      controller: brandController,                      onSubmitted: (text){brand = text;},                      decoration: InputDecoration(                          border: OutlineInputBorder(),                          constraints: BoxConstraints(                              maxHeight: 40                          )                      ),                    ),                  ),                  Container(                    margin: EdgeInsets.only(left: 10,right: 10),                    width: 80,                    child: ElevatedButton(                      child: Text('입력'),                      onPressed: (){                        setState(() {                          //brand = brandController.text;                        });                      },                    ),                  )                ],              )          ),          Expanded(              child: Row(                children: [                  Container(margin: EdgeInsets.only(left: 10,right: 10),child: Text('샷',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),                  Flexible(                    child:                    TextField(                      controller: brandController,                      onSubmitted: (text){brand = text;},                      decoration: InputDecoration(                          border: OutlineInputBorder(),                          constraints: BoxConstraints(                              maxHeight: 40                          )                      ),                    ),                  ),                  Container(                    margin: EdgeInsets.only(left: 10,right: 10),                    width: 80,                    child: ElevatedButton(                      child: Text('입력'),                      onPressed: (){                        setState(() {                          //brand = brandController.text;                        });                      },                    ),                  )                ],              )          ),          Expanded(              child: Row(                children: [                  Container(margin: EdgeInsets.only(left: 10,right: 10),child: Text('카페인',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),                  Flexible(                    child:                    TextField(                      controller: brandController,                      onSubmitted: (text){brand = text;},                      decoration: InputDecoration(                          border: OutlineInputBorder(),                          constraints: BoxConstraints(                              maxHeight: 40                          )                      ),                    ),                  ),                  Container(                    margin: EdgeInsets.only(left: 10,right: 10),                    width: 80,                    child: ElevatedButton(                      child: Text('입력'),                      onPressed: (){                        setState(() {                          //brand = brandController.text;                        });                      },                    ),                  )                ],              )          ),          Expanded(              child: Container(                margin: EdgeInsets.all(10),                child: Row(                  crossAxisAlignment: CrossAxisAlignment.center,                  children: [                    Expanded(                        child: Padding(                          padding: const EdgeInsets.only(top: 20,bottom: 20),                          child: Column(                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,                            crossAxisAlignment: CrossAxisAlignment.center,                            children: [                              Text(                                '카페인 함량',                                style: TextStyle(                                    fontSize: 15                                ),                              ),                            ],                          ),                        )                    ),                    Expanded(                        flex: 2,                        child: Container(                          padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5,),                          child: ElevatedButton(                            onPressed: (){                              //userCaffeineService.addNewUserCaffeine(today, UserCaffeine(drinkTime: time, menuId: _menu.id, brand: _brand, menuSize: _size, shotAdded: 0, caffeineContent: _caffeine, menuImg: _menu['menu_img']));                              Navigator.popUntil(context, (route) => route.isFirst);                            },                            child: Text(                              '기록하기',                              style: TextStyle(fontSize: 15),                            ),                            style: ElevatedButton.styleFrom(                                minimumSize: const Size.fromHeight(50),                                shape: RoundedRectangleBorder(                                    borderRadius: BorderRadius.circular(10)                                )                            ),                          ),                        )                    )                  ],                ),              )          ),        ],      ),    );  }  Future getImage(ImageSource imageSource) async {    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.    final XFile? pickedFile = await picker.pickImage(source: imageSource);    if (pickedFile != null) {      setState(() {        imageUpload = true;        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장      });    }  }  Future<void> _dialogBuilder(BuildContext context){    return showDialog(        context: context,        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부        builder: (BuildContext context) {          return AlertDialog(            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),            content: const Text("어떤 것으로 접근하시겠습니까?"),            insetPadding: const EdgeInsets.fromLTRB(10, 100, 10, 10),            actions: [              TextButton(                child: const Text("카메라"),                onPressed: () {                  getImage(ImageSource.camera);                  Navigator.pop(context);                },              ),              TextButton(                child: const Text("갤러리"),                onPressed: () {                    getImage(ImageSource.gallery);                    Navigator.pop(context);                },              ),            ],          );        }    );  }}