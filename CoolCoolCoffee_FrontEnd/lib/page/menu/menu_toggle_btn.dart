import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuToggleBtn extends StatefulWidget {
  final Map<String,dynamic> map;
  final List<bool> isSelected;
  const MenuToggleBtn({super.key, required this.isSelected, required this.map});

  @override
  State<MenuToggleBtn> createState() => _MenuToggleBtnState();
}

class _MenuToggleBtnState extends State<MenuToggleBtn> {
  late List<bool> _isSelected;
  late Map<String,dynamic> _map;
  @override
  void initState(){
    super.initState();
    _isSelected = widget.isSelected;
    _map = widget.map;
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
    /*Row(
      children: [
        for(var key in sizeSelected.keys)...[
          sizeSelected[key]!
              ? OutlinedButton(
              onPressed: (){
                setState(() {
                  for (var k in sizeSelected.keys) {
                    if (k == key) {
                      sizeSelected[k] = true;
                    } else {
                      sizeSelected[k] = false;
                    }
                    print('$k ${sizeSelected[k]}');
                  }
                });
              },
              child: Text(key,
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              ),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )
              )
          )
              :OutlinedButton(
              onPressed: (){
                setState(() {
                  for (var k in sizeSelected.keys) {
                    if (k == key) {
                      sizeSelected[k] = true;
                    } else {
                      sizeSelected[k] = false;
                    }
                    print('$k ${sizeSelected[k]}');
                  }
                });
              },
              child: Text(key,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )
              )
          ),
          Container(width: 10,)
        ]
      ],
    );*/
  }
  void toggleSelect(value){
    List<bool> list = List<bool>.filled(_isSelected.length, false);
    for(int i = 0;i<_isSelected.length;i++){
      if(i == value){
        list[i] = true;
      }
    }
    setState(() {
      _isSelected = list;
    });
  }
}

