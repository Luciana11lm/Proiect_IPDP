import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:menu_app/fragments/user/home_fragment_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen();

  final LinearGradient gradient = const LinearGradient(
    colors: [Color(0xfffb8500), Colors.white],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 600,
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
                Center(
                  child: Lottie.network(
                    'https://lottie.host/ffc14be8-8a26-41b0-bebf-07857c2368f4/2BXe5VOlCo.json',
                    height: 350,
                    width: 350,
                  ),
                ),
                const Align(
                  child: Text(
                    'Thank you for\n   your order',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Times New Roman'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  child: Text(
                    'You have booked a tabel for , on ',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Material(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => HomeFragmentScreen());
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 76, vertical: 12),
                        child: Align(
                          child: Text(
                            "Go home",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
