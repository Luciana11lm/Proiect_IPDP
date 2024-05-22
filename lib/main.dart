// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:menu_app/screens/onbording/views/onbording.dart';
import 'package:menu_app/test/test_database_connection.dart';

void main() {
  //var db = new Mysql();

  WidgetsFlutterBinding.ensureInitialized();
  testDatabaseConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FutureBuilder(
        builder: (context, dataSnapshot) {
          return const OnBordingScreen();
        },
        future: null,
      ),
    );
  }
}
