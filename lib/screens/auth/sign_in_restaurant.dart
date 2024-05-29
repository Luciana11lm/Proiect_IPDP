import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/repositories/models/restaurant.dart';
import 'package:menu_app/repositories/restaurantPreferences/restaurant_preferences.dart';
import 'package:menu_app/fragments/admin/admin_upload_items.dart';
import 'package:menu_app/screens/auth/sign_in_screen.dart';
import '../../components/my_text_field.dart';
import 'package:http/http.dart' as http;

class SignInRestaurant extends StatefulWidget {
  const SignInRestaurant({super.key});

  @override
  State<SignInRestaurant> createState() => _SignInRestaurantState();
}

class _SignInRestaurantState extends State<SignInRestaurant> {
  final passwordRestaurantController = TextEditingController();
  final idRestaurantController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  LinearGradient gradient = const LinearGradient(
    colors: [Color(0xfffb8500), Colors.white],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  loginUserNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.logInRestaurant),
        body: {
          "idRestaurant": int.parse(idRestaurantController.text.trim())
              .toString(), //idRestaurantController.text.trim(),
          "passwordRestaurant": passwordRestaurantController.text.trim(),
        },
      );
      //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      if (res.statusCode == 200) {
        var resBodyOfLogIn = jsonDecode(res.body);
        if (resBodyOfLogIn['success']) {
          Fluttertoast.showToast(msg: "Logged in successfully.");
          Restaurant restaurantInfo =
              Restaurant.fromJson(resBodyOfLogIn["restaurantData"]);
          //se salveaza informatiile restaurantului in local storage cu SharedPreferences
          await RememberRestaurantPrefs.storeRestaurantInfo(restaurantInfo);
          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(() => AdminUploadItems());
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
                              child: MyTextField(
                                controller: idRestaurantController,
                                hintText: 'Restaurant Unic Identifier',
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                prefixIcon:
                                    const Icon(CupertinoIcons.lock_fill),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return '     Please fill in this field';
                                  } else if (!RegExp(r'^[0-9]+$')
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
                              child: MyTextField(
                                controller: passwordRestaurantController,
                                hintText: 'Password',
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                prefixIcon:
                                    const Icon(CupertinoIcons.lock_fill),
                                errorMsg: _errorMsg,
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
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                      if (obscurePassword) {
                                        iconPassword = CupertinoIcons.eye_fill;
                                      } else {
                                        iconPassword =
                                            CupertinoIcons.eye_slash_fill;
                                      }
                                    });
                                  },
                                  icon: Icon(iconPassword),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                          height: 280,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Sign In for clients',
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
