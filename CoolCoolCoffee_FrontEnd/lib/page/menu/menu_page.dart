
import 'package:coolcoolcoffee_front/page/menu/general_menu_add_page.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_list_view.dart';
import 'package:coolcoolcoffee_front/page/menu/search_page.dart';
import 'package:coolcoolcoffee_front/page/menu/star_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/star_provider.dart';
import 'brand_list_view.dart';
import 'camera_button.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  String _brand = '더벤티';
  _changeBrandCallback(String brand) => setState((){
    _brand = brand;
  });
  _changeStarCallback(String id) => setState((){
    ref.watch(starsProvider.notifier).remove(id);
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(starsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F8F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
              Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
            _brand,
          style: const TextStyle(
            color: Colors.black
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (
                    context) =>SearchPage()));
              },
              icon: Icon(Icons.search,)
            ),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (
                    context) =>StarPage(starCallback: _changeStarCallback,)));
              },
              icon: Icon(Icons.star_border_rounded,),
            /*Image.asset(
                "assets/star_unfilled_with_outer.png",
                fit: BoxFit.fill,
              ),*/
            ),
        ],
      ),
      body:Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
                height: 80,
                margin: const EdgeInsets.all(5),
                child: Expanded(child: BrandListView(brandCallback: _changeBrandCallback,))),
            Expanded(
              flex: 9,
              child: MenuListView(brandName: _brand,)
            )
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment(
              Alignment.bottomRight.x,Alignment.bottomRight.y - 0.25,
            ),
            child: const CameraButton(),
          ),
          Align(
            alignment: Alignment(Alignment.bottomRight.x,Alignment.bottomRight.y-0.02),
            child: FloatingActionButton(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              backgroundColor: const Color(0xff93796A),
              focusColor: const Color(0xffF9F8F7),
              child: const Icon(Icons.add,color: Colors.white,),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const GeneralMenuAddPage()));
              },
            ),
          )
        ],
      )
    );
  }
}
