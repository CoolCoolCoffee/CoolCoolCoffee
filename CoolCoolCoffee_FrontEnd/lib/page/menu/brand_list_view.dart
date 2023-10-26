import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BrandListView extends StatefulWidget {
  const BrandListView({super.key});

  @override
  State<BrandListView> createState() => _BrandListViewState();
}

class _BrandListViewState extends State<BrandListView> {
  final CollectionReference _brand = FirebaseFirestore.instance.collection('Cafe_brand');

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
                    return const SizedBox(width: 12);
                  },
                  itemBuilder: (context,index){
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 5,
                            ),
                            CircleAvatar(
                              radius: 25,
                                backgroundImage: NetworkImage(documentSnapshot['logo_img']),
                            ),
                            Text(documentSnapshot.id)
                            /*Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                visualDensity: VisualDensity(vertical: -4, horizontal: 0),
                                title: Text(documentSnapshot.id),
                                leading: CircleAvatar(backgroundImage: NetworkImage(documentSnapshot['logo_img'])),
                                subtitle: Text(size_map_to_string(documentSnapshot['sizes'])),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
            else{
              return Text('failed');
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


