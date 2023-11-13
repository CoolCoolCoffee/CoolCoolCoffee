import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:intl/intl.dart';

import '../provider/user_provider.dart';

class UserFavoriteDrinkService {
  final userFavoriteDrinkCollection = FirebaseFirestore.instance.collection('Users').doc('ZZDgEPAMHTeb57Ox1aSgtqOXpMB2').collection('user_favorite');

  Future<void> checkExits() async{
    var wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    if(!wait.exists){
      List<dynamic> lists = [];
      await userFavoriteDrinkCollection.doc('favorite_drink').set({'drink_list': lists});
    }
  }
  //user_favorite_drink에 존재하는지 확인해주는 함수 - 일단은 menu_id , brand가 동일한 메뉴가 있는지 확인
  Future<bool> checkFavoriteDrinkExists(UserFavoriteDrink userFavoriteDrink) async{
    var wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    bool ret = false;
    if(wait.exists){
      List<dynamic> lists = wait['drink_list'];
      for(var list in lists){
        if((list['brand'] == userFavoriteDrink.brand)&&(list['menu_id'] == userFavoriteDrink.menuId)){
          ret = true;
        }
      }
    }
    return ret;
  }
  //없으면 CREATE 있으면 UPDATE
  Future<void> addNewUserFavoriteDrink(UserFavoriteDrink userFavoriteDrink) async{
    var wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    if(!wait.exists){
      List<dynamic> lists = [userFavoriteDrink.toMap()];
      await userFavoriteDrinkCollection.doc('favorite_drink').set({'drink_list': lists});
    }else{
      //위의 검사랑은 살짝 다르다는 걸 인식하고 있어야함.
      //위의 함수는 brand, menu_id가 같은면 같다고 인식
      // 아래의 함수는 size 등 세부정보가지 전부 같아야 같다고 인식
      List<dynamic> lists = wait['drink_list'];
      lists.add(userFavoriteDrink.toMap());
      await userFavoriteDrinkCollection.doc('favorite_drink').update({'drink_list': lists});
    }
  }
  //READ
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserFavoriteDrink() async{
    var wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    if(!wait.exists){
      List<dynamic> lists = [];
      await userFavoriteDrinkCollection.doc('favorite_drink').set({'drink_list': lists});
      wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    }
    //var wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    return wait;
  }
  //Delete
  Future<void> deleteUserFavoriteDrink(UserFavoriteDrink userFavoriteDrink) async{
    var wait = await userFavoriteDrinkCollection.doc('favorite_drink').get();
    List<dynamic> lists = wait['drink_list'];
    for(var list in lists){
      if((list['brand'] == userFavoriteDrink.brand)&&(list['menu_id'] == userFavoriteDrink.menuId)){
        lists.remove(list);
        break;
      }
    }
    await userFavoriteDrinkCollection.doc('favorite_drink').update({'drink_list': lists});
  }
}