// ignore_for_file: unnecessary_this

class User {
  int? idUser;
  String firstName;
  String lastName;
  String email;
  String password;
  String role;

  // constructor
  User(
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.role,
  );

  // constructor cu id
  User.withId(
    this.idUser,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.role,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(json["firstName"],
      json["lastName"], json["email"], json["password"], json["role"]);

  // Metodă pentru a converti un obiect User într-un JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': this.firstName.toString(),
      'lastName': this.lastName.toString(),
      'email': this.email.toString(),
      'password': this.password.toString(),
      'role': this.role.toString(),
    };
  }
}
