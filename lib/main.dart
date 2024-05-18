import 'package:flutter/material.dart';
import 'package:menu_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:menu_app/repositories/user_repository.dart';
import 'package:menu_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:menu_app/screens/home/views/home_screen.dart';
import 'package:menu_app/screens/onbording/views/onbording.dart';
import 'package:menu_app/test/test_database_connection.dart';
import 'package:provider/provider.dart';

void main() {
  // URL-ul de bază pentru comunicarea cu serverul
  const baseUrl = 'http://menuipdp.000webhostapp.com/db.php';

  // Inițializarea obiectului UserRepository
  final userRepository = UserRepository(Uri.parse(baseUrl), baseUrl: baseUrl);
  WidgetsFlutterBinding.ensureInitialized();
  testDatabaseConnection();
  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => UserRepository(Uri.parse(baseUrl), baseUrl: baseUrl),
        ),
        Provider<SignInBloc>(
          create: (_) => SignInBloc(userRepository),
        ),
        Provider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: MyApp(userRepository: userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: FutureBuilder(
        future: userRepository
            .user.last, // Verificăm starea de autentificare a utilizatorului
        builder: (context, snapshot) {
          if (!userRepository.dataLoaded) {
            return const CircularProgressIndicator(); // Afișăm un indicator de încărcare
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // Dacă utilizatorul este autentificat, afișăm ecranul principal
              return const HomeScreen();
            } else {
              // Dacă utilizatorul nu este autentificat, afișăm ecranul de onboarding
              return const OnBordingScreen();
            }
          }
        },
      ),
    );
  }
}
