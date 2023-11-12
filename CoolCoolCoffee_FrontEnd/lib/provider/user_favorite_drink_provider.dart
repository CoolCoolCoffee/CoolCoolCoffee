import 'package:coolcoolcoffee_front/service/user_favorite_drink_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final userFavoriteDrinkProv = StateProvider<UserFavoriteDrinkService>((ref){
  return UserFavoriteDrinkService();
});