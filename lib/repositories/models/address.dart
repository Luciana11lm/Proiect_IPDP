class Address {
  final int id;
  final String street;
  final String city;
  final String country;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      city: json['city'],
      country: json['country'],
    );
  }
}
