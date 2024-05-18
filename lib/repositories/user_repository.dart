import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

class UserRepository {
  final String baseUrl;
  late final StreamController<User?> _userController;
  bool dataLoaded = false;

  UserRepository(Uri parse, {required this.baseUrl}) {
    _userController = StreamController<User?>.broadcast();
    _loadUserFromPrefs();
  }

  Stream<User?> get user => _userController.stream;

  Future<User?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final user = User.fromJson(data['user']);
          _saveUserToPrefs(user);
          _userController.add(user);
          return user;
        }
      }
    } catch (e) {
      print('Error signing in: $e');
    }
    return null;
  }

  Future<bool> signUp(
      String firstName, String lastName, String email, String password) async {
    try {
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
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('password');
      _userController.add(User.empty);
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<void> _saveUserToPrefs(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', user.email);
      await prefs.setString(
          'password', ''); // Pentru simplificare, nu salvăm parola
    } catch (e) {
      print('Error saving user to prefs: $e');
    }
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';
      final password = prefs.getString('password') ?? '';

      if (email.isNotEmpty && password.isNotEmpty) {
        final user = await signIn(email, password);
        _userController.add(user);
      } else {
        _userController.add(User.empty);
      }
      dataLoaded = true;
    } catch (e) {
      print('Error loading user from prefs: $e');
    }
  }
}
