import 'package:flutter/material.dart';
import 'package:menu_app/models/food.dart';

class Restaurant extends ChangeNotifier {
  final List<Food> _menu = [
    //burgers
    Food(
      name: "Cheeseburger",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "Cheeseburger 2",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "Cheeseburger 3",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    //salad
    Food(
      name: "Salad 1",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "salad 2",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "salad 3",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    //sides
    Food(
      name: "side 1",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "side 2",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "side 3",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    //deserts
    Food(
      name: "desert 1",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.deserts,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "desert 2",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.deserts,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "desert 3",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.deserts,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    //drinks
    Food(
      name: "soda 1",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "soda 2",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
    Food(
      name: "soda 3",
      description:
          "Carne de vită, sos Chili Mayo, brânză Cheddar, mix salată, roșii felii, ceapă roșie,muraturi ,chifle pufoase cu unt aromatizat.",
      imagePath: 'assets/cheeseburger.jpeg',
      price: 19.99,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Branza extra", price: 2),
        Addon(name: "Bacon", price: 2),
      ],
    ),
  ];

  //getters
  List<Food> get menu => _menu;
}
