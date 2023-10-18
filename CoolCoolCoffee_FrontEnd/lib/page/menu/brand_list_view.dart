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
    return Scaffold(
      body: StreamBuilder(
          stream: _brand.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if(streamSnapshot.hasData){
              return ListView.builder(
                //scrollDirection: Axis.horizontal,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        visualDensity: VisualDensity(vertical: -4, horizontal: 0),
                        title: Text(documentSnapshot.id),
                        leading: CircleAvatar(backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/coolcoolcoffee-2a74f.appspot.com/o/%5B106509%5D_20210430111852999.jpg?alt=media&token=346fcaf5-08c5-438d-af9a-58e9b9d01ae1&_gl=1*t99zkq*_ga*MjAxNDY2NjEyMy4xNjkzNjMyNTQx*_ga_CW55HF8NVT*MTY5NzYyMDQ5MS4xMy4xLjE2OTc2MjI0MzMuMjEuMC4w')),
                        /*Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/coolcoolcoffee-2a74f.appspot.com/o/9p8OVxJTce_f2HnuZF1QOU6qMSHqXBHdkcx3q_hlGxvhcyaOXKxBVyoDkeg-Cb4Nx2p60W0AUh6RzjAH59vHwQ.svg?alt=media&token=9fc9dfa1-adb4-47d6-91cd-e97133913983&_gl=1*byloaq*_ga*NTUwNDcxODM0LjE2OTY0MjUzNjk.*_ga_CW55HF8NVT*MTY5NzUxNTMwNi4xNC4xLjE2OTc1MTc2NDUuMTkuMC4w",
                          width: 10.0,
                          height: 10.0,
                        ),*/
                        subtitle: Text(size_map_to_string(documentSnapshot['sizes'])),

                      ),
                    );
                  }
              );
            }
            else{
              return Text('failed');
            }
          }),
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


