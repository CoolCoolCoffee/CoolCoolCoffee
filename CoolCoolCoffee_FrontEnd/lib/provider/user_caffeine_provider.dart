import 'package:coolcoolcoffee_front/model/user_caffeine.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final userCaffeineProvider = StateProvider<UserCaffeineService>((ref){
  return UserCaffeineService();
});