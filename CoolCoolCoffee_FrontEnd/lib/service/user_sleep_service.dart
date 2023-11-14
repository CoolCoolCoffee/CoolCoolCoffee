import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_sleep.dart';

class UserSleepService{
  final userSleepCollection = FirebaseFirestore.instance.collection('Users').doc('ZZDgEPAMHTeb57Ox1aSgtqOXpMB2').collection('user_sleep');


  //READ
  // Future<DocumentSnapshot<Map<String, dynamic>>> getUserSleep(String date, UserSleep userSleep) async{
  //   var wait = await userSleepCollection.doc(date).get();
  //   return wait;
  // }

  Future<int?> getSleepQualityScore(String date) async {
    try {
      DocumentSnapshot<
          Map<String, dynamic>> snapshot = await userSleepCollection.doc(date)
          .get();
      if (snapshot.exists) {
        //print("tlqkf : $snapshot");
        var qualityScore = snapshot.data()?['sleep_quality_score'];
        if (qualityScore is int) {
          return qualityScore;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting sleep quality score: $e');
      return null;
    }
  }

  Future<String?> getSleepTime(String date) async {
    try {
      DocumentSnapshot<
          Map<String, dynamic>> snapshot = await userSleepCollection.doc(date)
          .get();
      if (snapshot.exists) {
        //print("tlqkf : $snapshot");
        var sleepTime = snapshot.data()?['sleep_time'];
        if (sleepTime is String) {
          return sleepTime;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting sleep time: $e');
      return null;
    }
  }

  Future<String?> getWakeTime(String date) async {
    try {
      DocumentSnapshot<
          Map<String, dynamic>> snapshot = await userSleepCollection.doc(date)
          .get();
      if (snapshot.exists) {
        //print("tlqkf : $snapshot");
        var wakeTime = snapshot.data()?['wake_time'];
        if (wakeTime is String) {
          return wakeTime;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting wake time: $e');
      return null;
    }
  }

  // void printAllDocumentIds() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //     await userSleepCollection.get();
  //
  //     for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
  //     in querySnapshot.docs) {
  //       print("Document ID: ${docSnapshot.id}");
  //     }
  //   } catch (e) {
  //     print('Error printing document IDs: $e');
  //   }
  // }
}