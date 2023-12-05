import 'package:coolcoolcoffee_front/page/menu/serach_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final _brandList = ['전체','더벤티','매머드커피','메가커피','빽다방','스타벅스','이디야','커피빈','컴포즈커피','투썸플레이스','편의점','할리스'];
  String _selectedBrand = '전체';
  String _menu = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedBrand = _brandList[0];
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메뉴 검색',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 24
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 5),
                        child: DropdownButton(
                          //underline: Container(width: 20,),
                          value: _selectedBrand,
                          items: _brandList.map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          )).toList(),
                          onChanged: (value){
                            setState(() {
                              _selectedBrand = value!;
                            });
                          },
                        ),
                      ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 5,right: 5),
                        color: Colors.white,
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "메뉴를 입력해주세요",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )
                          ),
                          onEditingComplete: (){
                              setState(() {
                                _menu = _searchController.text;
                              });
                          },
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
          Expanded(
            flex: 7,
              child: (_menu !='')?SearchListView(brand: _selectedBrand,menu: _menu,):Container(
                color: Colors.white,
              ),
          ),
        ],
      )
    );
  }
}
