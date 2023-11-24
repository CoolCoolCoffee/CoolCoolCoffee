import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/function/camera_functions.dart';
import 'package:coolcoolcoffee_front/page/menu/brand_check.dart';
import 'package:coolcoolcoffee_front/page/menu/loading_menu.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_add_page.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../camera/camera_page.dart';

class CameraButton extends StatefulWidget {
  const CameraButton({super.key});

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> with SingleTickerProviderStateMixin{
  Animation<double>? _animation;
  AnimationController? _animationController;
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  bool ice = false;
  String brand = "";
  String menu = "";

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  Future getImage(ImageSource imageSource, String cameraMode) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
      getRecognizedText(_image!,cameraMode);
    }
  }

  void getRecognizedText(XFile image, String cameraMode) async {
    // XFile 이미지를 InputImage 이미지로 변환
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final korTextRecognizer =
    TextRecognizer(script: TextRecognitionScript.korean);
    RecognizedText korRecognizedText =
    await korTextRecognizer.processImage(inputImage);
    await korTextRecognizer.close();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoadingMenu()));

    if(cameraMode=="Starbucks label"){
      var ret = await CameraFunc().fetchMenuFromStarbucksLabel(korRecognizedText);
      if(ret["success"]){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MenuAddPage(menuSnapshot: ret["document"], brandName: ret["brand"], size: ret["size"],shot: ret["shot"],)));
      }else{
        Navigator.pop(context);
        _failedDialogBuilder(context);
      }
    }
    else if(cameraMode=="App Capture"){
      var ret = await CameraFunc().fetchMenuFromAppCature(korRecognizedText);
      if(ret["success"]){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MenuAddPage(menuSnapshot: ret["document"], brandName: ret["brand"], size: ret["size"],shot: "",)));
      }else{
        Navigator.pop(context);
        _failedDialogBuilder(context);
      }
    }
    else{
      await fetchMenuFromConveni(korRecognizedText);
    }
  }
  Future<void> fetchMenuFromConveni(RecognizedText recText) async{
    print("Hi!!!conveni");
  }
  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Starbucks label",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.label_outline_rounded,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _dialogBuilder(context, "Starbucks label");
            },
          ),
          Bubble(
            title: "App Capture",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.screenshot_outlined,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _dialogBuilder(context, "App Capture");
            },
          ),
          Bubble(
            title: "conveni",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.local_convenience_store_rounded,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _dialogBuilder(context, "conveni");
            },
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
            ? _animationController!.reverse()
            : _animationController!.forward(),
        backGroundColor: Colors.blue,
        iconColor: Colors.white,
        iconData: Icons.camera_alt_outlined,
    );
  }

  Future<void> _failedDialogBuilder(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
            content: const Text("메뉴 분석에 실패했습니다."),
            insetPadding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
            actions: [
              TextButton(
                child: const Text("닫기"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
  Future<void> _dialogBuilder(BuildContext context, String cameraMode){
    return showDialog(
        context: context,
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
            content: const Text("어떤 것으로 접근하시겠습니까?"),
            insetPadding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
            actions: [
              TextButton(
                child: const Text("카메라"),
                onPressed: () {
                  getImage(ImageSource.camera, cameraMode);
                },
              ),
              TextButton(
                child: const Text("갤러리"),
                onPressed: () {
                  if(cameraMode == "conveni"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage(cameraMode: cameraMode, cameraGallery: 'gallery')));
                  }else{
                    getImage(ImageSource.gallery, cameraMode);
                  }
                },
              ),
            ],
          );
        }
    );
  }
}
