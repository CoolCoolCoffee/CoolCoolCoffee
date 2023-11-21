import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BrandInfo extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const BrandInfo({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  State<BrandInfo> createState() => _BrandInfoState();
}

class _BrandInfoState extends State<BrandInfo> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  getUserInfo() async {
    var result = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .collection('user_favorite')
        .doc('favorite_brand').get();
    return result.data();
  }
  
  Widget brandInfoWidget({required Map<String, dynamic> userData}){
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> brand_list = List<String>.from(userData['brand_list'] ?? []);
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(' 선호 브랜드', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),),
            IconButton(
              onPressed: (){
                // showEditBrandDialog(brand_list);
              },
              icon: const Icon(Icons.edit),
              iconSize: 20,)
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        const Text('1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                        Text(brand_list[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      Text(brand_list[1], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      Text(brand_list[2], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(), // 이 부분은 변경하지 않아도 됩니다.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var userData = snapshot.data as Map<String, dynamic>;

            return brandInfoWidget(userData: userData);
          } else {
            return Text('No dadta available');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
