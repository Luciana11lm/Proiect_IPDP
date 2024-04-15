import 'dart:async';

import 'package:flutter/material.dart';
import 'package:menu_app/screens/home/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initstate() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      print('fjsbjbvs');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeSceen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () {
                initState();
              },
              child: Text('schimba'),
            )
          ],
        ),
      ),
    );
  }
}
