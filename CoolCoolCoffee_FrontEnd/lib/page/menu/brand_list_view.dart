import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BrandListView extends StatefulWidget {
  final Function brandCallback;
  const BrandListView({super.key, required this.brandCallback});

  @override
  State<BrandListView> createState() => _BrandListViewState();
}

class _BrandListViewState extends State<BrandListView> {
  late Function _brandCallback;
  final CollectionReference _brand = FirebaseFirestore.instance.collection('Cafe_brand');
  @override
  void initState() {
    _brandCallback = widget.brandCallback;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
          stream: _brand.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if(streamSnapshot.hasData){
              return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: streamSnapshot.data!.docs.length,
                  separatorBuilder: (context,index){
                    return Container(width: 5,);
                  },
                  itemBuilder: (context,index){
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        _brandCallback(documentSnapshot.id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey,width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 80,
                        height: 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 5,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                                backgroundImage: NetworkImage(documentSnapshot['logo_img']),
                            ),
                            SizedBox(height: 2,),
                            Text(
                                documentSnapshot.id,
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
            else{
              return CircularProgressIndicator(color: Colors.blue,);
            }
          },
    );
  }

  String size_map_to_string(Map<String,dynamic> sizes){
    String size = "";
    for (var key in sizes.keys) {
      size = size +" " + "$key";
    }
    return size;
  }


}


