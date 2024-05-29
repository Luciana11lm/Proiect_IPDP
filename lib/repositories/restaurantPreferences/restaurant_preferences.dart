import 'dart:convert';
import 'package:menu_app/repositories/models/restaurant.dart'; // Asigură-te că ai importat modelul corect pentru un restaurant
import 'package:shared_preferences/shared_preferences.dart';

class RememberRestaurantPrefs {
  // Salvează informațiile despre restaurant local
  static Future<void> storeRestaurantInfo(Restaurant restaurantInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String restaurantJsonData = jsonEncode(restaurantInfo.toJson());
    await preferences.setString("currentRestaurant", restaurantJsonData);
  }

  // Citește informațiile despre restaurant
  static Future<Restaurant?> readRestaurantInfo() async {
    Restaurant? currentRestaurantInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? restaurantInfo = preferences.getString("currentRestaurant");
    if (restaurantInfo != null) {
      Map<String, dynamic> restaurantDataMap = jsonDecode(restaurantInfo);
      currentRestaurantInfo = Restaurant.fromJson(restaurantDataMap);
    }
    return currentRestaurantInfo;
  }

  // Șterge informațiile despre restaurant
  static Future<void> removeRestaurantInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentRestaurant");
  }
}
