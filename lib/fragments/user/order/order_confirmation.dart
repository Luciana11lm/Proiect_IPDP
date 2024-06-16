import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/dashboard_of_fragments.dart';
import 'package:menu_app/fragments/user/home_fragment_screen.dart';
import 'package:http/http.dart' as http;
import 'package:menu_app/fragments/user/profile_fragment_screen.dart';
import 'package:menu_app/repositories/models/order.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';

class OrderConfirmationScreen extends StatefulWidget {
  OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  CurrentUser currentUser = Get.put(CurrentUser());
  Orders? recentOrderInfo;

  @override
  void initState() {
    super.initState();
    getRecentOrderInformation();
  }

  int index = 0;

  void getRecentOrderInformation() async {
    try {
      var res = await http.post(
        Uri.parse(API.getRecentOrder),
        body: {
          "idUser": currentUser.user.idUser.toString(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfRecentOrderDetails = jsonDecode(res.body);
        if (resBodyOfRecentOrderDetails['success']) {
          setState(() {
            recentOrderInfo =
                Orders.fromJson(resBodyOfRecentOrderDetails["orderData"]);
          });
        } else {
          Fluttertoast.showToast(msg: "Not found.");
        }
      } else {
        print("Problema pe undeva ");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  final LinearGradient gradient = const LinearGradient(
    colors: [Color(0xfffb8500), Colors.white],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    String formattedDate = recentOrderInfo != null
        ? DateFormat('d MMMM yyyy').format(recentOrderInfo!.orderDateTime!)
        : '';
    String formattedTime = recentOrderInfo != null
        ? DateFormat('HH:mm').format(recentOrderInfo!.bookingDateTime!)
        : '';

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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    recentOrderInfo != null
                        ? 'You have booked a table for ${recentOrderInfo!.numberOfPeople}, \n on ${formattedDate} at ${formattedTime}.'
                        : 'Loading...',
                    textAlign: TextAlign.center,
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
                        while (index < 3) {
                          Navigator.pop(context);
                          index++;
                        }
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
