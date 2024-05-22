// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/dashboard_of_fragments.dart';
import 'package:menu_app/repositories/models/user.dart';
import 'package:menu_app/screens/auth/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/fragments/admin/admin_upload_items.dart';
import '../../components/my_text_field.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final idUserController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ValueNotifier<String> roleController = ValueNotifier<String>('client');
  //final roleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  LinearGradient gradient = const LinearGradient(
    colors: [Color(0xfffb8500), Colors.white],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // functie pentru validarea email-ului - verific daca mai exista un user in db care are mailul introdus
  validateUserEmail() async {
    try {
      // rastpunsul de la server la verificarea daca emailul exista deja
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'email': emailController.text.trim(),
        },
      );
      if (res.statusCode ==
          200) //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      {
        var resBodyOfValidateEmail = jsonDecode(res.body);
        if (resBodyOfValidateEmail['emailFound']) {
          Fluttertoast.showToast(
              msg: "Email is already in use. Try another email.");
        } else {
          //register & save new user record in database
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async {
    User userModel = User(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        roleController.value);
    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['success']) {
          Fluttertoast.showToast(msg: "Sign up successfully");
          setState(() {
            firstNameController.clear();
            lastNameController.clear();
            emailController.clear();
          });
          // ne mutam pe pagina principala
          if (roleController.value == "client") {
            Future.delayed(const Duration(microseconds: 2000), () {
              Get.to(() => DashboardOfFragments());
            });
          } else {
            Future.delayed(const Duration(microseconds: 2000), () {
              Get.to(() => AdminUploadItems());
            });
          }
        } else {
          Fluttertoast.showToast(msg: "Error occurred. Try again.");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // containerul din exterior cu degrade definit ca LinearGradient
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          // container-ul alb in care este formularul
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
                const SizedBox(height: 10),
                SizedBox(
                  height: 200, // inălțimea containerului pentru imagine
                  child: Image.asset(
                    'assets/logo_app.png',
                  ),
                ),
                Form(
                    key: _formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(),
                          child: Column(
                            children: [
                              // chenar pentru introducerea PRENUMELUI
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfffb8500),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    // introducere PRENUME
                                    child: MyTextField(
                                        controller: firstNameController,
                                        hintText: 'First Name',
                                        obscureText: false,
                                        keyboardType: TextInputType.name,
                                        prefixIcon: const Icon(
                                            CupertinoIcons.person_fill),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please fill in this field';
                                          } else if (val.length > 30) {
                                            return 'Name too long';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // chenar pentru introducerea NUMELUI
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfffb8500),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    // introducere NUME
                                    child: MyTextField(
                                        controller: lastNameController,
                                        hintText: 'Last Name',
                                        obscureText: false,
                                        keyboardType: TextInputType.name,
                                        prefixIcon: const Icon(
                                            CupertinoIcons.person_fill),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please fill in this field';
                                          } else if (val.length > 30) {
                                            return 'Name too long';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // chenar pentru introducerea EMAILULUI
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
                                        controller: emailController,
                                        hintText: 'Email',
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        prefixIcon: const Icon(
                                            CupertinoIcons.mail_solid),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please fill in this field';
                                          } else if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                              .hasMatch(val)) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // chenar pentru introducerea PAROLEI
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
                                    // introducerea PAROLEI
                                    child: MyTextField(
                                        controller: passwordController,
                                        hintText: 'Password',
                                        obscureText: obscurePassword,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        prefixIcon: const Icon(
                                            CupertinoIcons.lock_fill),
                                        onChanged: (val) {
                                          if (val!.contains(RegExp(r'[A-Z]'))) {
                                            setState(() {
                                              containsUpperCase = true;
                                            });
                                          } else {
                                            setState(() {
                                              containsUpperCase = false;
                                            });
                                          }
                                          if (val.contains(RegExp(r'[a-z]'))) {
                                            setState(() {
                                              containsLowerCase = true;
                                            });
                                          } else {
                                            setState(() {
                                              containsLowerCase = false;
                                            });
                                          }
                                          if (val.contains(RegExp(r'[0-9]'))) {
                                            setState(() {
                                              containsNumber = true;
                                            });
                                          } else {
                                            setState(() {
                                              containsNumber = false;
                                            });
                                          }
                                          if (val.contains(RegExp(
                                              r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                                            setState(() {
                                              containsSpecialChar = true;
                                            });
                                          } else {
                                            setState(() {
                                              containsSpecialChar = false;
                                            });
                                          }
                                          if (val.length >= 8) {
                                            setState(() {
                                              contains8Length = true;
                                            });
                                          } else {
                                            setState(() {
                                              contains8Length = false;
                                            });
                                          }
                                          return null;
                                        },
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              obscurePassword =
                                                  !obscurePassword;
                                              if (obscurePassword) {
                                                iconPassword =
                                                    CupertinoIcons.eye_fill;
                                              } else {
                                                iconPassword = CupertinoIcons
                                                    .eye_slash_fill;
                                              }
                                            });
                                          },
                                          icon: Icon(iconPassword),
                                        ),
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return 'Please fill in this field';
                                          } else if (!RegExp(
                                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                              .hasMatch(val)) {
                                            return 'Please enter a valid password';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "    1 uppercase",
                                        style: TextStyle(
                                            color: containsUpperCase
                                                ? const Color.fromARGB(
                                                    255, 66, 187, 192)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                      ),
                                      Text(
                                        "    1 lowercase",
                                        style: TextStyle(
                                            color: containsLowerCase
                                                ? const Color.fromARGB(
                                                    255, 66, 187, 192)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                      ),
                                      Text(
                                        "    1 number",
                                        style: TextStyle(
                                            color: containsNumber
                                                ? const Color.fromARGB(
                                                    255, 66, 187, 192)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "    1 special character",
                                        style: TextStyle(
                                            color: containsSpecialChar
                                                ? const Color.fromARGB(
                                                    255, 66, 187, 192)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                      ),
                                      Text(
                                        "    8 minimum character",
                                        style: TextStyle(
                                            color: contains8Length
                                                ? const Color.fromARGB(
                                                    255, 66, 187, 192)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // selectie tip de utilizator - admin/client
                              ValueListenableBuilder<String>(
                                valueListenable: roleController,
                                builder: (context, value, child) {
                                  return SizedBox(
                                    width: 250,
                                    child: DropdownButtonFormField<String>(
                                      value: value,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 235, 193, 5),
                                            width: 0.1,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                      ),
                                      onChanged: (String? newValue) {
                                        roleController.value = newValue!;
                                      },
                                      items: <String>['client', 'admin']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Center(child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              !signUpRequired
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      child: TextButton(
                                          onPressed: () {
                                            // verificam daca au fost introduse toate datele
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //verificam daca mai exista un user cu acelasi mail
                                              validateUserEmail();
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                              elevation: 3.0,
                                              backgroundColor:
                                                  const Color(0xfffb8500),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          60))),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 5),
                                            child: Text(
                                              'Sign Up',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )),
                                    )
                                  : const CircularProgressIndicator(),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(height: 10),

                              // trimitere catre pagina de SIGNIN daca are deja cont
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()),
                                  );
                                },
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Sign in",
                                        style: TextStyle(
                                          color: Color(0xfffb8500),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
