import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/menu.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';

class StarbucksLabel extends StatefulWidget {
  final String cameraMode;
  final String cameraGallery;
  const StarbucksLabel({Key? key, required this.cameraMode,required this.cameraGallery}) : super(key: key);

  @override
  State<StarbucksLabel> createState() => _StarbucksLabelState();
}

class _StarbucksLabelState extends State<StarbucksLabel> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String engScannedText = "";
  String korScannedText = "";
  bool ice = false;
  String full_menu_name = "";
  late Future<String> fetchMenu;
  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
      getRecognizedText(_image!);
    }
  }

  void getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final korTextRecognizer =
    TextRecognizer(script: TextRecognitionScript.korean);
    RecognizedText korRecognizedText =
    await korTextRecognizer.processImage(inputImage);
    await korTextRecognizer.close();
    korScannedText = "";
    for (TextBlock block in korRecognizedText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains(RegExp(r'S\)|T\)|G\)|V\)'))) {
          korScannedText = korScannedText + line.text + "\n";
        }else if(line.text == 'ice'){
          ice = true;
        }
      }
    }
    final starbucks_menu = korScannedText.split(' ');
    fetchMenu = fetchMenuName(starbucks_menu[1]);
    full_menu_name = fetchMenu as String;
    setState(() {});
  }
  Future<String> fetchMenuName(String starbucks_acro) async{
    String menu_name = "";
    final starbucks_ = await FirebaseFirestore.instance
        .collection('Cafe_brand')
        .doc('스타벅스')
        .collection('starbucks_label')
        .get()
        .then((subcol) {
      subcol.docs.forEach((element) {
        if(starbucks_acro.trim() == element.id.trim()){
          print("dfdfdfd!!");
          if(ice){
            menu_name = element['ice'];
          }else{
            menu_name = element['hot'];
          }
        }
      });
    });
    return menu_name;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("${widget.cameraMode}")),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${widget.cameraGallery}"),
              SizedBox(height: 30, width: double.infinity),
              _buildPhotoArea(),
              _buildKorRecognizedText(),
              SizedBox(height: 20),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 300,
      height: 300,
      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    );
  }
  Widget _buildKorRecognizedText() {
    return Text(full_menu_name); //getRecognizedText()에서 얻은 scannedText 값 출력
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }
}