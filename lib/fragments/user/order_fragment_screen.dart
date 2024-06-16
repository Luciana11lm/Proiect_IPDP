import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/order/order_details.dart';
import 'package:menu_app/repositories/models/order.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';

class OrderFragmentScreen extends StatelessWidget {
  CurrentUser currentUser = Get.put(CurrentUser());

  Future<List<Orders>> getRecentOrderInformation() async {
    List<Orders> ordersListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.readOrders),
        body: {
          "idUser": currentUser.user.idUser.toString(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfUserOrderDetails = jsonDecode(res.body);
        if (resBodyOfUserOrderDetails['success']) {
          (resBodyOfUserOrderDetails['orderData'] as List)
              .forEach((eachUserOrder) {
            print('eachUserOrder: ${eachUserOrder}');
            ordersListOfCurrentUser.add(Orders.fromJson(eachUserOrder));
          });
        } else {
          Fluttertoast.showToast(msg: "Not orders found.");
        }
      } else {
        print("Problema pe undeva ");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }

    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: displayOrderList(context),
          ),
        ],
      ),
    );
  }

  Widget displayOrderList(BuildContext context) {
    return FutureBuilder(
      future: getRecentOrderInformation(),
      builder: (contex, AsyncSnapshot<List<Orders>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('Connection Waiting...'),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.connectionState == null) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('No orders found yet.'),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }

        if (dataSnapshot.data!.length > 0) {
          List<Orders> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.all(16),
            separatorBuilder: (contex, index) {
              return const Divider(
                height: 0,
                thickness: 0,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (contex, index) {
              Orders eachOrderData = orderList[index];
              print('orderList.selectedItems: ${eachOrderData.selectedItmes}');
              return Card(
                color: Colors.white70,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: ListTile(
                    // display order information
                    onTap: () {
                      print(
                          'eachOrderData.selectedItmes: ${eachOrderData.selectedItmes}');
                      Get.to(
                          OrderDetailsScreen(clickedOrderInfo: eachOrderData));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID #' + eachOrderData.idOrder.toString(),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Total amount ' +
                              eachOrderData.totalPrice.toString() +
                              '\$',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 71, 23, 23),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // display date and time
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //diplay date
                            Text(
                              DateFormat("dd MMMM, yyyy")
                                  .format(eachOrderData.bookingDateTime!),
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            //diplay date
                            Text(
                              DateFormat("hh:mm a")
                                  .format(eachOrderData.bookingDateTime!),
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                child: Text('Nothing fount.'),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
