import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/models/restaurant.dart';
import 'package:menu_app/screens/home/views/home_screen.dart';
import 'package:menu_app/screens/onbording/views/onbording.dart';
import 'package:menu_app/simple_bloc_observer.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int _primaryValue = 0xfffb8500;
    const MaterialColor customSwatch = MaterialColor(
      _primaryValue,
      <int, Color>{
        50: Color(0xffffebcc),
        100: Color(0xffffd699),
        200: Color(0xffffc266),
        300: Color(0xffffad33),
        400: Color(0xffff9900),
        500: Color(_primaryValue),
        600: Color(0xffe67e00),
        700: Color(0xffcc7400),
        800: Color(0xffb36900),
        900: Color(0xff995e00),
      },
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, _) {
          return MaterialApp(
            home: authService.isAuthenticated
                ? const HomeScreen()
                : const OnBordingScreen(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: customSwatch,
            ),
          );
        },
      ),
    );
  }
}
