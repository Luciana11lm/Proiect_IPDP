import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/user.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<User?> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return User.fromJson(data['user']);
      }
    }
    return null;
  }

  Future<bool> signUp(
      String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup.php'),
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );

    final data = jsonDecode(response.body);
    return data['status'] == 'success';
  }
}
