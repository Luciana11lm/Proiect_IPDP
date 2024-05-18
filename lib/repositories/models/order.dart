import 'extra_ingredients.dart';
import 'product.dart';

class Order {
  final int id;
  final List<Product> products; // Lista de produse din comandă
  final Map<Product, List<ExtraIngredients>>
      productsWithExtras; // Produsele din comandă cu ingredientele suplimentare asociate
  final double totalPrice; // Prețul total al comenzii

  Order({
    required this.id,
    required this.products,
    required this.productsWithExtras,
    required this.totalPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parsăm lista de produse din comandă
    List<Product> products = (json['products'] as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();

    // Parsăm lista de produse cu ingrediente suplimentare
    Map<Product, List<ExtraIngredients>> productsWithExtras = {};
    json['productsWithExtras'].forEach((productJson, extrasJson) {
      Product product = Product.fromJson(productJson);
      List<ExtraIngredients> extras = (extrasJson as List)
          .map((extraJson) => ExtraIngredients.fromJson(extraJson))
          .toList();
      productsWithExtras[product] = extras;
    });

    return Order(
      id: json['id'],
      products: products,
      productsWithExtras: productsWithExtras,
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}
