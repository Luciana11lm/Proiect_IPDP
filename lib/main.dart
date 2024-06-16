// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:menu_app/fragments/user/dashboard_of_fragments.dart';
import 'package:menu_app/fragments/user/home_fragment_screen.dart';
import 'package:menu_app/repositories/userPreferences/user_preferences.dart';
import 'package:menu_app/screens/onbording/views/onbording.dart';
import 'package:menu_app/test/test_database_connection.dart';
import 'package:menu_app/test/test_restaurant_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  testDatabaseConnection();
  testRestaurantConnection();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool('rememberMe') ?? false;
  runApp(MyApp(rememberMe: rememberMe));
}

class MyApp extends StatelessWidget {
  final bool rememberMe;

  const MyApp({Key? key, required this.rememberMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapshot) {
          if ((dataSnapshot.data != null) && (rememberMe == true)) {
            return DashboardOfFragments();
          } else {
            return const OnBordingScreen();
          }
        },
      ),
    );
  }
}
