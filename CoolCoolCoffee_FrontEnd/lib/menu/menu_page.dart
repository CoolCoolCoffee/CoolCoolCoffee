import 'package:coolcoolcoffee_front/camera/camera_page.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin{
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
    return Scaffold(
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Starbucks label",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.label_outline_rounded,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              //_animationController!.reverse();
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage("Starbucks label")));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage("App Capture")));

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage("conveni")));
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
      ),
    );
  }
}
