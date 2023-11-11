import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  late String _userName = '';
  late int _userAge = 0;
  late TimeOfDay _bedTime = TimeOfDay(hour: 0, minute: 0);
  late TimeOfDay _wakeTime = TimeOfDay(hour: 0, minute: 0);
  late int _goalSleepTimeHour = 0;
  late int _goalSleepTimeMin = 0;

  late List<String> _favoriteBrand;

  String get userName => _userName;
  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  int get userAge => _userAge;
  set userAge(int value) {
    _userAge = value;
    notifyListeners();
  }

  TimeOfDay get bedTime => _bedTime;
  set bedTime(TimeOfDay value) {
    _bedTime = value;
    notifyListeners();
  }

  TimeOfDay get wakeTime => _wakeTime;
  set wakeTime(TimeOfDay value) {
    _wakeTime = value;
    notifyListeners();
  }

  int get goalSleepTimeHour => _goalSleepTimeHour;
  set goalSleepTimeHour(int value) {
    _goalSleepTimeHour = value;
    notifyListeners();
  }

  int get goalSleepTimeMin => _goalSleepTimeMin;
  set goalSleepTimeMin(int value) {
    _goalSleepTimeMin = value;
    notifyListeners();
  }

  List<String> get favoriteBrand => _favoriteBrand;
  set favoriteBrand(List<String> value) {
    _favoriteBrand = value;
    notifyListeners();
  }
}

class UserRepository {
  Future<void> saveUserToDatabase(UserProvider userProvider) async {
    // 파이어베이스에 있는 사용자 인증 정보 가져와서
    FirebaseAuth auth = FirebaseAuth.instance;

    // 현재 로그인 한 사용자 객체를 불러와서
    User? user = auth.currentUser;

    // 사용자가 로그인 상태라면
    if(user != null) {
      // 파이어베이스에 회원가입 시 받은 사용자 정보들을 저장하자
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'user_name' : userProvider.userName,
        'age': userProvider.userAge,
        'avg_bed_time' : userProvider.bedTime,
        'avg_wake_time' : userProvider.wakeTime,
        'goal_sleep_time' : mappingGoalSleepTime(userProvider.goalSleepTimeHour, userProvider.goalSleepTimeMin),
      });

      DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      await userDocRef.collection('user_favorite').add({
        'favorite_brand' : FieldValue.arrayUnion(userProvider.favoriteBrand),
      });
    } else {  // 사용자 로그인 상태가 아니면 에러 발생
      print('No user is currently signed in.');
    }
  }

  Map<String, int> mappingGoalSleepTime(int hour, int min){
    return {
      'hour' : hour,
      'min' : min,
    };
  }

}