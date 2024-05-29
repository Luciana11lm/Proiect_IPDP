import 'package:get/state_manager.dart';
import 'package:menu_app/repositories/models/restaurant.dart';
import 'package:menu_app/repositories/restaurantPreferences/restaurant_preferences.dart'; // Asigură-te că importul este corect pentru preferințele restaurantului

class CurrentRestaurant extends GetxController {
  final Rx<Restaurant> _currentRestaurant = Restaurant().obs;

  Restaurant get restaurant => _currentRestaurant.value;

  Future<void> getRestaurantInfo() async {
    Restaurant? restaurantInfoFromLocalStorage =
        await RememberRestaurantPrefs.readRestaurantInfo();
    if (restaurantInfoFromLocalStorage != null) {
      _currentRestaurant.value = restaurantInfoFromLocalStorage;
    }
  }
}
