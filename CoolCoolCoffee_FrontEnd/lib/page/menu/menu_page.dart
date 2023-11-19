
import 'package:coolcoolcoffee_front/page/menu/menu_list_view.dart';
import 'package:coolcoolcoffee_front/page/menu/star_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/star_provider.dart';
import '../../service/user_favorite_drink_service.dart';
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
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: [
          FractionallySizedBox(
            heightFactor: 0.7,
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (
                    context) =>StarPage(starCallback: _changeStarCallback,)));
              },
              icon: Image.asset(
                "assets/star_unfilled_with_outer.png",
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
      body:Column(
        children: [
          Container(height: 20,),
          Expanded(child: BrandListView(brandCallback: _changeBrandCallback,)),
          Expanded(
            flex: 9,
            child: MenuListView(brandName: _brand,)
          )
        ],
      ),
      floatingActionButton: CameraButton(),
    );
  }
}
