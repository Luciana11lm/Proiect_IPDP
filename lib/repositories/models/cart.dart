class Cart {
  int? idCart;
  int? idProduct;
  int? idRestaurant;
  int? idUser;
  int? quantity;
  String? sizeCart;
  String? name;
  double? price;
  List<String>? ingredients;
  String? description;
  String? imageUrl;
  double? rating;
  List<String>? tags;
  List<String>? sizes;

  Cart({
    this.idCart,
    this.idProduct,
    this.idRestaurant,
    this.idUser,
    this.quantity,
    this.sizeCart,
    this.name,
    this.price,
    this.ingredients,
    this.description,
    this.imageUrl,
    this.rating,
    this.tags,
    this.sizes,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      idCart: int.parse(json["idCart"]),
      idRestaurant: int.parse(json["idRestaurant"]),
      idUser: int.parse(json["idUser"]),
      quantity: int.parse(json["quantity"]),
      sizeCart: json["sizeCart"],
      idProduct: int.parse(json["idProduct"]),
      name: json["name"],
      price: double.parse(json["price"]),
      ingredients: json["ingredients"].toString().split(", "),
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: double.parse(json["rating"]),
      tags: json["tags"].toString().split(", "),
      sizes: json["size"].toString().split(", "),
    );
  }
}
