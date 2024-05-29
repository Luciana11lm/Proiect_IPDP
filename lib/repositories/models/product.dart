class Product {
  int? idProduct;
  String? name;
  double? price;
  List<String>? ingredients;
  String? description;
  String? imageUrl;
  double? rating;
  List<String>? tags;
  int? idRestaurant;
  List<String>? sizes;

  Product({
    this.idProduct,
    this.name,
    this.price,
    this.ingredients,
    this.description,
    this.imageUrl,
    this.rating,
    this.tags,
    this.idRestaurant,
    this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: int.parse(json["idProduct"]),
      name: json["name"],
      price: double.parse(json["price"]),
      ingredients: json["ingredients"].toString().split(", "),
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json["rating"]),
      tags: json["tags"].toString().split(", "),
      idRestaurant: int.parse(json["idRestaurant"]),
      sizes: json["size"].toString().split(", "),
    );
  }
}
