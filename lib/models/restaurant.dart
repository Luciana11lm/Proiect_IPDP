import 'package:menu_app/models/food.dart';

class Restaurant {
  final List<Food> _menu = [
    Food(
      name: "Cheeseburger",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/chesseburger.jpeg',
      price: 19.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
  ];
}
