import 'package:cloud_firestore/cloud_firestore.dart';

class UserSleep{
  String? docID;
  final String sleep_quality_score;
  final String sleep_time;
  final num wake_time;

  UserSleep({
    this.docID,
    required this.sleep_quality_score,
    required this.sleep_time,
    required this.wake_time,
  });
}