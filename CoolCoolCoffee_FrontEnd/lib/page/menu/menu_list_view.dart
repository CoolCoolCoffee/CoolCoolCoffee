import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_add_page.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_add_page_prov.dart';
import 'package:coolcoolcoffee_front/page/menu/star_icon_button.dart';
import 'package:coolcoolcoffee_front/service/user_favorite_drink_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MenuListView extends StatefulWidget {
  final String brandName;
  const MenuListView({super.key, required this.brandName,});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  late UserFavoriteDrinkService userFavoriteDrinkService;
  @override
  void initState() {
    userFavoriteDrinkService = UserFavoriteDrinkService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String brand_name = widget.brandName;
    final CollectionReference _menu = FirebaseFirestore.instance.collection('Cafe_brand').doc(brand_name).collection('menus');

    return StreamBuilder(
        stream: _menu.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return GridView.builder(
              shrinkWrap: true,
              itemCount: streamSnapshot.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index){
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                bool isStared = false;
                Future<bool> checkStar = userFavoriteDrinkService.checkFavoriteDrinkExists(UserFavoriteDrink(menuId: documentSnapshot.id, brand: brand_name), );
                checkStar.then((value) {isStared = value; print("${documentSnapshot.id} $isStared");});

                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuAddPage(menuSnapshot: documentSnapshot, brandName: brand_name, size: '', shot: '',)));
                  },
                  child: //SingleChildScrollView(
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 5.0,
                                    offset: Offset(0,5)
                                )],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(documentSnapshot['menu_img'])
                              )
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 5,right: 5),
                              height: 50,
                              width: 50,
                              child: IconButton(
                                icon: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if(isStared) Image.asset(
                                        "assets/filled_star.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      )
                                      else Image.asset(
                                        "assets/star_unfilled_without_outer.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                      Image.asset(
                                        "assets/star_unfilled_with_outer.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                    ]
                                ),
                                onPressed: (){
                                },
                              ),
                              //StarIconButton(isStared: isStared,)
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                               alignment: Alignment.bottomLeft,
                              height: 50,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      spreadRadius: 0,
                                      blurRadius: 5.0,
                                      offset: Offset(0,5)
                                  )]
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                      brand_name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                    ),
                                  ),
                                  Text(documentSnapshot.id)],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                );
              },

            );
          }
          else{
            return Text('failed');
          }
      },
    );
  }

}
