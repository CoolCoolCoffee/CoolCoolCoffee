import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:intl/intl.dart';

import '../provider/user_provider.dart';

class UserFavoriteDrinkService {
  final userFavoriteDrinkCollection = FirebaseFirestore.instance.collection('Users').doc('ZZDgEPAMHTeb57Ox1aSgtqOXpMB2').collection('user_favorite').doc('favorite_drink');

  //없으면 CREATE 있으면 UPDATE
  Future<void> addNewUserFavoriteDrink(UserFavoriteDrink userFavoriteDrink) async{
    var wait = await userFavoriteDrinkCollection.get();
    if(!wait.exists){
      List<dynamic> lists = [userFavoriteDrink.toMap()];
      await userFavoriteDrinkCollection.set({'favorite_drink': lists});
    }else{
      List<dynamic> lists = wait['favorite_drink'];
      int count = 0;
      for(var list in lists){
        if(list == userFavoriteDrink.toMap()){
          count++;
          break;
        }
      }
      if(count == 0){
        lists.add(userFavoriteDrink.toMap());
      }
      await userFavoriteDrinkCollection.update({'favorite_drink': lists});
    }
  }
  //READ
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserFavoriteDrink() async{
    var wait = await userFavoriteDrinkCollection.get();
    return wait;
  }
  //Delete
  Future<void> deleteUserFavoriteDrink(UserFavoriteDrink userFavoriteDrink) async{
    var wait = await userFavoriteDrinkCollection.get();
    List<dynamic> lists = wait['caffeine_list'];
    for(var list in lists){
      if(list == userFavoriteDrink.toMap()){
        lists.remove(list);
        break;
      }
    }
    await userFavoriteDrinkCollection.update({'caffeine_list': lists});
  }
}