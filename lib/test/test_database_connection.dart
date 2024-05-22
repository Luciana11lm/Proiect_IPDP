// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:menu_app/api_connection/api_connection.dart';

void testDatabaseConnection() async {
  try {
    final response = await http.get(Uri.parse(API.hostConnect));
    if (response.statusCode == 200) {
      print(
          'Conexiunea cu baza de date este stabilă. Răspuns: ${response.body}');
    } else {
      print(
          'Eroare la comunicarea cu baza de date. Cod de stare: ${response.statusCode}');
    }
  } catch (e) {
    print('Eroare la comunicarea cu baza de date: $e');
  }
}
