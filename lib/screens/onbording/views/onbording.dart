import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menu_app/screens/auth/views/sign_in_screen.dart';
import 'package:menu_app/screens/onbording/views/intro_screens/intro_page3.dart';
import 'package:menu_app/screens/onbording/views/intro_screens/intro_page_1.dart';
import 'package:menu_app/screens/onbording/views/intro_screens/intro_page_2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBordingScreenState createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  final PageController _controller = PageController();

  //keep track if we're on the last page
  bool onLastPage = false;

  //keep track of page number
  int _currentPageIndex = 0;

  //timer for every page
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (_currentPageIndex < 2) {
          _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //page view
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                Visibility(
                  visible: !onLastPage,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.aBeeZee(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
                //dot indicators
                onLastPage
                    ? Padding(
                        padding: const EdgeInsets.only(left: 33),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                              controller: _controller,
                              count: 3,
                              effect: const WormEffect(
                                  activeDotColor: Color(0xFFFB8500)),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                              controller: _controller,
                              count: 3,
                              effect: const WormEffect(
                                  activeDotColor: Color(0xFFFB8500)),
                            ),
                          ],
                        ),
                      ),
                //next or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Done',
                          style: GoogleFonts.aBeeZee(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          'Next',
                          style: GoogleFonts.aBeeZee(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
