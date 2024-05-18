import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:menu_app/repositories/models/user.dart';
import 'package:menu_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:menu_app/screens/auth/views/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/my_text_field.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            setState(() {
              signUpRequired = false;
            });
          } else if (state is SignUpProcess) {
            setState(() {
              signUpRequired = true;
            });
          } else if (state is SignUpFailure) {
            return;
          }
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: gradient,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Center(
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
                      height: 200, // Înălțimea containerului pentru imagine
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
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
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
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: MyTextField(
                                            controller: passwordController,
                                            hintText: 'Password',
                                            obscureText: obscurePassword,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            prefixIcon: const Icon(
                                                CupertinoIcons.lock_fill),
                                            onChanged: (val) {
                                              if (val!
                                                  .contains(RegExp(r'[A-Z]'))) {
                                                setState(() {
                                                  containsUpperCase = true;
                                                });
                                              } else {
                                                setState(() {
                                                  containsUpperCase = false;
                                                });
                                              }
                                              if (val
                                                  .contains(RegExp(r'[a-z]'))) {
                                                setState(() {
                                                  containsLowerCase = true;
                                                });
                                              } else {
                                                setState(() {
                                                  containsLowerCase = false;
                                                });
                                              }
                                              if (val
                                                  .contains(RegExp(r'[0-9]'))) {
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
                                                    iconPassword =
                                                        CupertinoIcons
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                        .onBackground),
                                          ),
                                          Text(
                                            "    1 lowercase",
                                            style: TextStyle(
                                                color: containsLowerCase
                                                    ? const Color.fromARGB(
                                                        255, 66, 187, 192)
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                          ),
                                          Text(
                                            "    1 number",
                                            style: TextStyle(
                                                color: containsNumber
                                                    ? const Color.fromARGB(
                                                        255, 66, 187, 192)
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
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
                                                        .onBackground),
                                          ),
                                          Text(
                                            "    8 minimum character",
                                            style: TextStyle(
                                                color: contains8Length
                                                    ? const Color.fromARGB(
                                                        255, 66, 187, 192)
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xfffb8500),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: MyTextField(
                                            controller: nameController,
                                            hintText: 'Name',
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
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  !signUpRequired
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: TextButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  User myUser = User(
                                                    email: emailController.text,
                                                    firstName:
                                                        nameController.text,
                                                    lastName:
                                                        nameController.text,
                                                    password:
                                                        passwordController.text,
                                                    role: 'user',
                                                  );

                                                  setState(() {
                                                    context
                                                        .read<SignUpBloc>()
                                                        .add(SignUpRequired(
                                                          firstName:
                                                              myUser.firstName,
                                                          lastName:
                                                              myUser.lastName,
                                                          email: myUser.email,
                                                          password:
                                                              myUser.password,
                                                        ));
                                                  });
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
                                                    horizontal: 25,
                                                    vertical: 5),
                                                child: Text(
                                                  'Sign Up',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )),
                                        )
                                      : const CircularProgressIndicator(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Divider(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Or Sign Up With',
                                          style: TextStyle(
                                            color: Color.fromRGBO(0, 0, 0, 0.2),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Divider(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            height: 36,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  ElevatedButton(
                                    onPressed: () {
                                      // se duce la alta pagina
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      elevation:
                                          MaterialStateProperty.all<double>(2),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(color: Colors.black),
                                      ),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(250,
                                            50), // Lățime și înălțime minime pentru buton
                                      ),
                                      maximumSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(250,
                                            50), // Lățime și înălțime maxime pentru buton
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign up with Google',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // se duce la alta pagina
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      elevation:
                                          MaterialStateProperty.all<double>(4),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(color: Colors.black),
                                      ),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(250,
                                            50), // Lățime și înălțime minime pentru buton
                                      ),
                                      maximumSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(250,
                                            50), // Lățime și înălțime maxime pentru buton
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign up with Apple',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => SignInBloc(
                                              context
                                                  .read<AuthenticationBloc>()
                                                  .userRepository,
                                            ),
                                            child: const SignInScreen(),
                                          ),
                                        ),
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
        ));
  }
}
