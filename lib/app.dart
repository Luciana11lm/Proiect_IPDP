import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/app_view.dart';
import 'package:menu_app/screens/home/views/splash_screen.dart';
import 'package:user_repository/user_repository.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
