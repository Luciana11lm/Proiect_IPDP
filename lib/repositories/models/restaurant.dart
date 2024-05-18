import 'address.dart';

import 'menu.dart'; // Importăm clasa Menu pentru a folosi meniurile în restaurant

class Restaurant {
  final int id;
  final String name;
  final Address address; // Adresa restaurantului
  final Menu menu; // Meniul restaurantului

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: Address.fromJson(json['address']),
      menu: Menu.fromJson(json['menu']),
    );
  }
}
