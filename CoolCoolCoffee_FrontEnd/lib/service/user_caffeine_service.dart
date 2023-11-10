import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_caffeine.dart';

import '../provider/user_provider.dart';

class UserCaffeineService {
  final userCaffeineCollection = FirebaseFirestore.instance.collection('Users').doc('ZZDgEPAMHTeb57Ox1aSgtqOXpMB2').collection('user_caffeine');
  //CREATE
  void addNewUserCaffeine(UserCaffeine userCaffeine){
    userCaffeineCollection.add(userCaffeine.toMap());
  }
  //READ

  //UPDATE

  //Delete
}