import 'product.dart';

class ExtraIngredients {
  final int id;
  final String name;
  final double price;
  final Product product; // Produsul la care se adaugă ingredientul suplimentar

  ExtraIngredients({
    required this.id,
    required this.name,
    required this.price,
    required this.product,
  });

  factory ExtraIngredients.fromJson(Map<String, dynamic> json) {
    return ExtraIngredients(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      product: Product.fromJson(
          json['product']), // Parsăm informațiile despre produs
    );
  }
}
