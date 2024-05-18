import 'menu.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl; // URL-ul imaginii produsului
  final String ingredients; // Ingrediente
  final String description; // Descriere
  final Menu menu; // Meniul în care se găsește produsul

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.ingredients,
    required this.description,
    required this.menu,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      ingredients: json['ingredients'],
      description: json['description'],
      menu: Menu.fromJson(json['menu']), // Parsăm informațiile despre meniu
    );
  }
}
