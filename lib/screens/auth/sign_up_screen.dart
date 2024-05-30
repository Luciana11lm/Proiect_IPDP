// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/dashboard_of_fragments.dart';
import 'package:menu_app/repositories/models/user.dart';
import 'package:menu_app/screens/auth/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        passwordController.text.trim());
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
          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(() => DashboardOfFragments());
          });
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
                                    child: TextFormField(
                                      controller: firstNameController,
                                      decoration: const InputDecoration(
                                        hintText: 'First Name',
                                        prefixIcon:
                                            Icon(CupertinoIcons.person_fill),
                                      ),
                                      obscureText: false,
                                      keyboardType: TextInputType.name,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please fill in this field';
                                        } else if (val.length > 30) {
                                          return 'Name too long';
                                        }
                                        return null;
                                      },
                                    ),
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
                                    child: TextFormField(
                                        controller: lastNameController,
                                        decoration: const InputDecoration(
                                          hintText: 'Last Name',
                                          prefixIcon: const Icon(
                                              CupertinoIcons.person_fill),
                                        ),
                                        obscureText: false,
                                        keyboardType: TextInputType.name,
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
                                    child: TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          hintText: 'Email',
                                          prefixIcon: const Icon(
                                              CupertinoIcons.mail_solid),
                                        ),
                                        obscureText: false,
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                    child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        prefixIcon: const Icon(
                                            CupertinoIcons.lock_fill),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              obscurePassword =
                                                  !obscurePassword;
                                              iconPassword = obscurePassword
                                                  ? CupertinoIcons.eye_fill
                                                  : CupertinoIcons
                                                      .eye_slash_fill;
                                            });
                                          },
                                          icon: Icon(iconPassword),
                                        ),
                                      ),
                                      obscureText: obscurePassword,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      onChanged: (val) {
                                        setState(() {
                                          containsUpperCase =
                                              val.contains(RegExp(r'[A-Z]'));
                                          containsLowerCase =
                                              val.contains(RegExp(r'[a-z]'));
                                          containsNumber =
                                              val.contains(RegExp(r'[0-9]'));
                                          containsSpecialChar = val.contains(RegExp(
                                              r'^(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'));
                                          contains8Length = val.length >= 8;
                                        });
                                      },
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please fill in this field';
                                        } else if (!RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                            .hasMatch(val)) {
                                          return 'Please enter a valid password';
                                        }
                                        return null;
                                      },
                                    ),
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
