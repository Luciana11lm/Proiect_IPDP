import "package:flutter/material.dart";
import "package:menu_app/components/my_drawer_tile.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:menu_app/screens/home/views/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //applog
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Image.asset(
              'assets/logo.png',
              scale: 5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),
          MyDrawerTile(
              text: "HOME",
              icon: Icons.home,
              onTap: () => Navigator.pop(context)),
          MyDrawerTile(
              text: "SETINGS",
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen()));
              }),
          const Spacer(),
          MyDrawerTile(
              text: "LOG OUT",
              icon: Icons.logout,
              onTap: () {
                context.read<SignInBloc>().add(SignOutRequired());
              })
        ],
      ),
    );
  }
}
