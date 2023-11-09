//현재 유저 uid를 통해 유저 정보 받아오기
//지금은 그냥 static하게 박아뒀음 -> 변경해야함
import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  var uid = 'ZZDgEPAMHTeb57Ox1aSgtqOXpMB2';
  Future<dynamic> fetchUser(String uid) async{
    QueryDocumentSnapshot<Map<String, dynamic>>? ret = null;
    var wait = await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((subcol) {
          subcol.docs.forEach((element) {
            if(element.id == uid) {ret = element;}
          });
        }
    );
    return ret;
  }

}