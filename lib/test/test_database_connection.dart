import 'package:http/http.dart' as http;

void testDatabaseConnection() async {
  try {
    final response =
        await http.get(Uri.parse('http://menuipdp.000webhostapp.com/db.php'));
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
