import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/models/cart_items.dart';
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
    List<CartItem> get cart => _cart;

  final List<CartItem> _cart = [];

  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons =
          ListEquality().equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });
    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);
    if (_cart[cartIndex].quantity > 1) {
      _cart[cartIndex].quantity--;
    } else {
      _cart.removeAt(cartIndex);
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;
      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;
    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
