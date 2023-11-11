import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuToggleBtn extends StatefulWidget {
  final Map<String,dynamic> map;
  final List<bool> isSelected;
  final Function callback;
  const MenuToggleBtn({super.key, required this.isSelected, required this.map, required this.callback});

  @override
  State<MenuToggleBtn> createState() => _MenuToggleBtnState();
}

class _MenuToggleBtnState extends State<MenuToggleBtn> {
  late List<bool> _isSelected;
  late Map<String,dynamic> _map;
  late Function _callback;
  @override
  void initState(){
    _isSelected = widget.isSelected;
    _map = widget.map;
    _callback = widget.callback;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Map<String,bool> sizeSelected = {};
    //for(var key in _map.keys){sizeSelected.addAll({key: false});}

    return Column(
      children: [
        ToggleButtons(
          color: Colors.black.withOpacity(0.60),
          selectedColor: Colors.blue,
          selectedBorderColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.08),
          splashColor: Colors.blue.withOpacity(0.12),
          hoverColor: Colors.blue.withOpacity(0.04),
          borderRadius: BorderRadius.circular(4.0),
          constraints: BoxConstraints(maxHeight: 40.0),
          children: [
            for(var key in _map.keys)...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: 75,
                child: Center(child: Text(key)),
              ),
            ],
          ],
          isSelected: _isSelected,
          onPressed: toggleSelect,
        ),
        Container(width: 10,)
      ],
    );
  }
  void toggleSelect(value){
    List<bool> list = List<bool>.filled(_isSelected.length, false);
    int i = 0;
    for(var key in _map.keys){
      if(i == value){
        _callback(key, _map[key]);
        print("${key} ${_map[key]}");
        list[i] = true;
      }
      i++;
    }
    setState(() {
      _isSelected = list;
    });
  }
}

