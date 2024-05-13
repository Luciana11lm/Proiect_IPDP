import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/models/restaurant.dart';
import 'package:menu_app/screens/onbording/views/onbording.dart';
import 'package:menu_app/simple_bloc_observer.dart';
import 'package:menu_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  //const MyAppWrapper({super.key});
  // ignore: use_super_parameters
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return const MaterialApp(
    //  home: OnBordingScreen(),
    //);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: const MaterialApp(
        home: OnBordingScreen(),
      ),
    );
  }
}
