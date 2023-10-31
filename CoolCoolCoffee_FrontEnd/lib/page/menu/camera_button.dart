
import 'package:coolcoolcoffee_front/page/camera/starbucks_label.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

import '../camera/camera_page.dart';

class CameraButton extends StatefulWidget {
  const CameraButton({super.key});

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> with SingleTickerProviderStateMixin{
  Animation<double>? _animation;
  AnimationController? _animationController;

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

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Starbucks label",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.label_outline_rounded,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              //_animationController!.reverse();
              _dialogBuilder(context, "Starbucks label");
            },
          ),
          Bubble(
            title: "App Capture",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.screenshot_outlined,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              //_animationController!.reverse();
              _dialogBuilder(context, "App Capture");
              //Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage("App Capture","camera")));
            },
          ),
          Bubble(
            title: "conveni",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.local_convenience_store_rounded,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              //_animationController!.reverse();
              _dialogBuilder(context, "conveni");
              //Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage("conveni","camera")));
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

  Future<void> _dialogBuilder(BuildContext context, String cameraMode){
    return showDialog(
        context: context,
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
            content: const Text("어떤 것으로 접근?"),
            insetPadding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
            actions: [
              TextButton(
                child: const Text("카메라"),
                onPressed: () {
                  if(cameraMode == "Starbucks label"){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StarbucksLabel(cameraMode: cameraMode, cameraGallery: "camera")));
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage(cameraMode: cameraMode, cameraGallery: "camera")));
                  }
                },
              ),
              TextButton(
                child: const Text("갤러리"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage(cameraMode: cameraMode, cameraGallery: "gallery")));
                },
              ),
            ],
          );
        }
    );
  }
}
