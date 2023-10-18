import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/menu/brand_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/brand.dart';

class BrandListView extends StatefulWidget {
  const BrandListView({super.key});

  @override
  State<BrandListView> createState() => _BrandListViewState();
}

class _BrandListViewState extends State<BrandListView> {
  final CollectionReference _brand = FirebaseFirestore.instance.collection('Cafe_brand');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _brand.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
            if(streamSnapshot.hasData){
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data.docs[index];
                    return Card(

                    )
                  }
              );
            }
          }),
    );
  }



}

