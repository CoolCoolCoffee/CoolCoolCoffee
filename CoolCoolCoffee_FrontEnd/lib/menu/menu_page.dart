import 'package:coolcoolcoffee_front/menu/camera_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        /*bottom: IconButton(
          onPressed: () {},
          icon: Icon(Icons.star),
        ),*/
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                iconSize: 100.0,
                  onPressed: () {

                },
                  icon: Icon(Icons.star)
              ),
              IconButton(
                  iconSize: 100.0,
                  onPressed: () {

                  },
                  icon: Icon(Icons.access_alarm)
              ),
              IconButton(
                  iconSize: 100.0,
                  onPressed: () {

                  },
                  icon: Icon(Icons.accessible_forward)
              ),
              IconButton(
                  iconSize: 100.0,
                  onPressed: () {

                  },
                  icon: Icon(Icons.ac_unit)
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CameraButton(),
    );
  }
}
