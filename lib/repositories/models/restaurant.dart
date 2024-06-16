class Restaurant {
  int? idRestaurant;
  String? name;
  String? city;
  String? street;
  String? number;
  String? description;
  String? imageRestaurantUrl;
  String? passwordRestaurant;

  Restaurant({
    this.idRestaurant,
    this.name,
    this.city,
    this.street,
    this.number,
    this.description,
    this.imageRestaurantUrl,
    this.passwordRestaurant,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      idRestaurant: int.parse(json["idRestaurant"]),
      name: json["name"],
      city: json["city"],
      street: json["street"],
      number: json["number"],
      description: json["description"],
      imageRestaurantUrl: json["imageRestaurantUrl"],
      passwordRestaurant: json["passwordRestaurant"]);

  // Metodă pentru a converti un obiect Restaurant într-un JSON
  Map<String, dynamic> toJson() {
    return {
      'idRestaurant': idRestaurant.toString(),
      'name': name.toString(),
      'city': city.toString(),
      'street': street.toString(),
      'description': description.toString(),
      'number': number.toString(),
      'imageRestaurantUrl': imageRestaurantUrl.toString(),
      'passwordRestaurant': passwordRestaurant.toString(),
    };
  }
}
