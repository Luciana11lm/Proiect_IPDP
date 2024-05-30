// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/dashboard_of_fragments.dart';
import 'package:menu_app/repositories/models/user.dart';
import 'package:menu_app/repositories/userPreferences/user_preferences.dart';
import 'package:menu_app/screens/auth/sign_in_restaurant.dart';
import 'package:menu_app/screens/auth/sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;
  bool rememberMe = false;

  LinearGradient gradient = const LinearGradient(
    colors: [Color(0xfffb8500), Colors.white],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Function to save rememberMe state
  void _saveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
  }

  // Function to load rememberMe state
  void _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  loginUserNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.logIn),
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );
      //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      if (res.statusCode == 200) {
        var resBodyOfLogIn = jsonDecode(res.body);
        if (resBodyOfLogIn['success']) {
          Fluttertoast.showToast(msg: "Logged in successfully.");
          User userInfo = User.fromJson(resBodyOfLogIn["userData"]);
          //se salveaza informatiile utilizatorului in local storage cu SharedPreferences
          await RememberUserPrefs.storeUserInfo(userInfo);
          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(() => DashboardOfFragments());
          });
        } else {
          Fluttertoast.showToast(msg: "Incorrect credentials.");
        }
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 753,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200, // Înălțimea containerului pentru imagine
                    child: Image.asset(
                      'assets/logo_app.png',
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: Icon(CupertinoIcons.mail_solid),
                                ),
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return '     Please fill in this field';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return '    Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon:
                                      const Icon(CupertinoIcons.lock_fill),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                        iconPassword = obscurePassword
                                            ? CupertinoIcons.eye_fill
                                            : CupertinoIcons.eye_slash_fill;
                                      });
                                    },
                                    icon: Icon(iconPassword),
                                  ),
                                ),
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return '     Please fill in this field';
                                  } else if (!RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                      .hasMatch(val)) {
                                    return '     Please enter a valid password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (newValue) {
                                    setState(() {
                                      rememberMe = newValue!;
                                    });
                                  },
                                  activeColor: const Color(0xfffb8500),
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.5),
                              child: GestureDetector(
                                onTap: () {
                                  // Adaugă aici logica pentru "Forgot password"
                                },
                                child: RichText(
                                  text: const TextSpan(
                                    text: 'Forgot password?',
                                    style: TextStyle(
                                      color: Color(0xfffb8500),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        !signInRequired
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      //functia pentru logare
                                      loginUserNow();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor: const Color(0xFFFB8500),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: Text(
                                      'Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.black.withOpacity(0.1),
                                  height: 30,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Or Sign In With',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.black.withOpacity(0.1),
                                  height: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // se duce la alta pagina
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.black),
                            elevation: WidgetStateProperty.all<double>(2),
                            side: WidgetStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.black),
                            ),
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size(250,
                                  50), // Lățime și înălțime minime pentru buton
                            ),
                            maximumSize: WidgetStateProperty.all<Size>(
                              const Size(250,
                                  50), // Lățime și înălțime maxime pentru buton
                            ),
                          ),
                          child: const Text(
                            'Sign in with Google',
                          ),
                        ),
                        const SizedBox(height: 13),
                        ElevatedButton(
                          onPressed: () {
                            // se duce la alta pagina
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.black),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            elevation: WidgetStateProperty.all<double>(4),
                            side: WidgetStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.black),
                            ),
                            minimumSize: WidgetStateProperty.all<Size>(
                              const Size(250,
                                  50), // Lățime și înălțime minime pentru buton
                            ),
                            maximumSize: WidgetStateProperty.all<Size>(
                              const Size(250,
                                  50), // Lățime și înălțime maxime pentru buton
                            ),
                          ),
                          child: const Text(
                            'Sign in with Apple',
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                    color: Color(0xfffb8500),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SignInRestaurant()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Sign In for restaurant owners',
                              style: TextStyle(
                                color: Color(0xfffb8500),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
