import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:menu_app/screens/auth/views/welcome_screen.dart';
import 'package:menu_app/screens/home/views/home_screen.dart';
import 'screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Menu',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => SignInBloc(
                    context.read<AuthenticationBloc>().userRepository),
                child: const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ));
  }
}
