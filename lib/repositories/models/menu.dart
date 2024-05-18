import 'product.dart';

import 'restaurant.dart';

class Menu {
  final int id;
  final Restaurant restaurant; // Restaurantul asociat cu meniul
  final List<Product> products; // Lista de produse din meniu

  Menu({
    required this.id,
    required this.restaurant,
    required this.products,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    // Parsăm lista de produse din JSON
    List<Product> productList = (json['products'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    return Menu(
      id: json['id'],
      restaurant: Restaurant.fromJson(
          json['restaurant']), // Parsăm informațiile despre restaurant
      products: productList,
    );
  }
}
