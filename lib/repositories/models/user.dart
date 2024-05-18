class User {
  final int? id;
  String email;
  String firstName;
  String lastName;
  String password;
  String role;

  User({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.role,
  });

  static var empty =
      User(email: '', firstName: '', lastName: '', password: '', role: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  // Metodă pentru a crea un obiect User dintr-un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
      role: json['role'],
    );
  }

  // Metodă pentru a converti un obiect User într-un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'role': role,
    };
  }
}
