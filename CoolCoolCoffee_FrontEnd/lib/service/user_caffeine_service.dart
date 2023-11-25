import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_caffeine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../provider/user_provider.dart';

class UserCaffeineService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  //final userCaffeineCollection = FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine');
  Future<void> checkExits(String date) async{
    var wait = await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).get();
    if(!wait.exists){
      List<dynamic> lists = [];
      await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).set({'caffeine_list': lists});
    }
  }
  //없으면 CREATE 있으면 UPDATE
  Future<void> addNewUserCaffeine(String date, UserCaffeine userCaffeine) async{
    var wait = await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).get();
    if(!wait.exists){
      List<dynamic> lists = [userCaffeine.toMap()];
      await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).set({'caffeine_list': lists});
    }else{
      List<dynamic> lists = wait['caffeine_list'];
      lists.add(userCaffeine.toMap());
      await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).update({'caffeine_list': lists});
    }
  }
  //READ
  Future<DocumentReference<Map<String, dynamic>>> getUserCaffeine(String date) async{
      var wait = await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date);
      return wait;
  }
  //Delete
  Future<void> deleteUserCaffeine(String date, UserCaffeine userCaffeine) async{
    var wait = await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).get();
    List<dynamic> lists = wait['caffeine_list'];
    for(var list in lists){
      if(list['drink_time'] == userCaffeine.drinkTime){
        lists.remove(list);
        break;
      }
    }
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_caffeine').doc(date).update({'caffeine_list': lists});
  }
}