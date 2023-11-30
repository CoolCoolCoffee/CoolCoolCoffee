import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuImgNameTile extends StatelessWidget {
  final String brandName;
  final DocumentSnapshot menuSnapshot;
  const MenuImgNameTile({super.key,required this.menuSnapshot, required this.brandName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 50,right: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(menuSnapshot['menu_img'])
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomLeft,
              height: 80,
              margin: const EdgeInsets.only(right: 50,left: 50),
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 0,
                      blurRadius: 5.0,
                      offset: const Offset(0,5)
                  )]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top:5, left: 10),
                    child: Text(
                      brandName,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      menuSnapshot.id,
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  )],
              ),
            ),
          )
        ],
      ),
    );
  }
}
