import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//import 'package:palette_generator/palette_generator.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';

class AppCapture extends StatefulWidget {
  final String cameraMode;
  final String cameraGallery;
  const AppCapture({Key? key, required this.cameraMode,required this.cameraGallery}) : super(key: key);

  @override
  State<AppCapture> createState() => _AppCaptureState();
}

class _AppCaptureState extends State<AppCapture> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String korScannedText = "";
  //String engScannedText = "";
  //List<PaletteColor> colors = [];
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
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final korTextRecognizer =
    TextRecognizer(script: TextRecognitionScript.korean);
    RecognizedText korRecognizedText =
    await korTextRecognizer.processImage(inputImage);
    await korTextRecognizer.close();
    korScannedText = "";
    for (TextBlock block in korRecognizedText.blocks) {
      for (TextLine line in block.lines) {
        korScannedText = korScannedText + line.text + "\n";
      }
    }
   /* final engTextRecognizer =
    TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText engRecognizedText =
    await engTextRecognizer.processImage(inputImage);
    await engTextRecognizer.close();
    engScannedText = "";
    for (TextBlock block in engRecognizedText.blocks) {
      for (TextLine line in block.lines) {
        engScannedText = engScannedText + line.text + "\n";
      }
    }*/

    /*final PaletteGenerator generator = await
    PaletteGenerator.fromImageProvider(
      Image.file(File(image.path)).image,
    );
    colors.clear();
    for (var color in generator.paletteColors) {
      colors.add(color);
      print(color.color.value.toRadixString(16).toString());
    }*/
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
              //_buildEngRecognizedText(),
              SizedBox(height: 20),
              _buildButton(),
             /* ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: colors.length,
                  itemBuilder: (context, index){
                    return Container(
                        height: 30,
                        margin: EdgeInsets.all(10),
                        color: colors[index].color,
                        child: Text(colors[index].color.value.toRadixString(16).toString()),
                      );
                  })*/
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
    return Text(korScannedText); //getRecognizedText()에서 얻은 scannedText 값 출력
  }
  /*Widget _buildEngRecognizedText() {
    return Text(engScannedText); //getRecognizedText()에서 얻은 scannedText 값 출력
  }*/

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