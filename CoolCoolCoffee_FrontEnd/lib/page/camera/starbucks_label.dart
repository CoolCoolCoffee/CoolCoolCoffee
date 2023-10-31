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
  String menu = "";
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

    // textRecognizer 초기화, 이때 script에 인식하고자하는 언어를 인자로 넘겨줌
    // ex) 영어는 script: TextRecognitionScript.latin, 한국어는 script: TextRecognitionScript.korean
   /* final engTextRecognizer =
    TextRecognizer(script: TextRecognitionScript.latin);
*/
    final korTextRecognizer =
    TextRecognizer(script: TextRecognitionScript.korean);
    // 이미지의 텍스트 인식해서 recognizedText에 저장
   /* RecognizedText engRecognizedText =
    await engTextRecognizer.processImage(inputImage);*/
    RecognizedText korRecognizedText =
    await korTextRecognizer.processImage(inputImage);

    // Release resources
    //await engTextRecognizer.close();
    await korTextRecognizer.close();
    // 인식한 텍스트 정보를 scannedText에 저장
    /*engScannedText = "";
    for (TextBlock block in engRecognizedText.blocks) {
      for (TextLine line in block.lines) {
        if(line.text.contains(RegExp(r'S\)|T\)|G\)|V\)')) || line.text == 'ice') {
          engScannedText = engScannedText + line.text + "\n";
        }
      }
    }*/

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
    setState(() {});
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

  /*Widget _buildEngRecognizedText() {
    return Text(engScannedText); //getRecognizedText()에서 얻은 scannedText 값 출력
  }*/
  Widget _buildKorRecognizedText() {
    return Text(korScannedText); //getRecognizedText()에서 얻은 scannedText 값 출력
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