import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'conveni_add_page.dart';
import 'menu_add_page_shot.dart';

final brandList = ['더벤티','매머드커피','메가커피','빽다방','스타벅스','이디야','커피빈','컴포즈커피','투썹플레이스','편의점','할리스'];
class SearchListView extends StatefulWidget {
  final String menu;
  final String brand;
  const SearchListView({super.key, required this.menu, required this.brand});

  @override
  State<SearchListView> createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  List<QueryDocumentSnapshot> list = [];
  List<String> brandPerQuery = [];

  var brandDocument;
  Future<void> _fetchBrand(DocumentSnapshot documentSnapshot,String brandName) async{
    DocumentSnapshot<Map<String,dynamic>> brandDoc =
    await FirebaseFirestore.instance.collection('Cafe_brand').doc(brandName).get();
    brandDocument = brandDoc;
    Navigator.push(context, MaterialPageRoute(builder: (
        context) =>
        MenuAddPageShot(menuSnapshot: documentSnapshot,
          brandSnapshot: brandDocument,
          size: '',
          shot: '',)));
    //setState(() {});
  }
  Widget _buildMenuItem(DocumentSnapshot documentSnapshot, String brandName){
    return GestureDetector(
      onTap: () {
        if (brandName == '편의점') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConveniAddPage(
                      menuSnapshot: documentSnapshot,
                      brandName: brandName)));
        } else {
          _fetchBrand(documentSnapshot, brandName);
        }
      },
      child: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color:
                        Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 5))
                  ],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          documentSnapshot['menu_img']))),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomLeft,
                height: 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 5))
                    ]),
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        brandName,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        documentSnapshot.id,
                        style: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<List<QueryDocumentSnapshot>> _fetchSearched(String menu, String brand) async{
    list = [];
    brandPerQuery = [];
    if(brand == '전체'){
      for(int i = 0;i<brandList.length;i++){
        await FirebaseFirestore.instance.collection('Cafe_brand').doc(brandList[i]).collection('menus').get().then(
                (value){
              value.docs.forEach((element) {
                if(element.id.contains(menu)){
                  list.add(element);
                  brandPerQuery.add(brandList[i]);
                }
              });
            }
        );
      }
    }
    else{
      await FirebaseFirestore.instance.collection('Cafe_brand').doc(brand).collection('menus').get().then(
              (value){
            value.docs.forEach((element) {
              if(element.id.contains(menu)){
                list.add(element);
                brandPerQuery.add(brand);
              }
            });
          }
      );
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchSearched(widget.menu,widget.brand),
        builder: (context, snapshot){
          if(snapshot.hasError) return Center(child: Text('검색 결과가 존재하지 않습니다.',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),);
          if(snapshot.hasData){
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: Container(
                  child: CircularProgressIndicator(color: Colors.blue,),
                  height: 50,
                  width: 50,
                ));
              default:
                return (list.length!=0)?
                GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = snapshot.data![index];
                      final String brandName = brandPerQuery[index];
                      return _buildMenuItem(documentSnapshot,brandName);
                    }
                ):
                Center(child: Text('검색 결과가 존재하지 않습니다.',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),);;
            }
          }else{
            return Center(child: Container(
              child: CircularProgressIndicator(color: Colors.blue,),
              height: 50,
              width: 50,
            ));
          }

        }
    );
  }
}
