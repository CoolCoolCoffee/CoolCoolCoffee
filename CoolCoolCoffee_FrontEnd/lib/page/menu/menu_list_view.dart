import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_add_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MenuListView extends StatefulWidget {
  final String brandName;
  const MenuListView({super.key, required this.brandName,});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {

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
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index){
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuAddPage(menuSnapshot: documentSnapshot, brandName: brand_name,)));
                  },
                  child: //SingleChildScrollView(
                    //scrollDirection: Axis.vertical,
                    //child:
                    Container(
                      //color: Colors.blue,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              //color: Colors.green,
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
                                icon: Image.asset(
                                    "assets/star_unfilled_without_outer.png",
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.fill,
                                ),
                                onPressed: (){

                                },
                              ),
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
