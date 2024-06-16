import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/admin/update_status.dart';
import 'package:menu_app/repositories/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:menu_app/repositories/restaurantPreferences/current_restaurant.dart';
import 'package:status_change/status_change.dart';

class AdminOrdersFragment extends StatefulWidget {
  @override
  State<AdminOrdersFragment> createState() => _AdminOrdersFragmentState();
}

class _AdminOrdersFragmentState extends State<AdminOrdersFragment> {
  CurrentRestaurant currentRestaurant = Get.put(CurrentRestaurant());

  int _index = 0;

  Future<List<Orders>> getRecentOrderInformation() async {
    List<Orders> ordersListOfCurrentRestaurant = [];
    try {
      var res = await http.post(
        Uri.parse(API.getOrdersRestaurantList),
        body: {
          "idRestaurant": currentRestaurant.restaurant.idRestaurant.toString(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfRestaurantOrderDetails = jsonDecode(res.body);
        if (resBodyOfRestaurantOrderDetails['success']) {
          (resBodyOfRestaurantOrderDetails['orderData'] as List)
              .forEach((eachUserOrder) {
            ordersListOfCurrentRestaurant.add(Orders.fromJson(eachUserOrder));
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

    return ordersListOfCurrentRestaurant;
  }

  List<String> getSelectedItems(Orders order) {
    return order.selectedItmes?.split('||') ?? [];
  }

  void setStatusOrder(int idOrder, String status) async {
    try {
      var res = await http.post(
        Uri.parse(API.setNewStatusOfOrder),
        body: {
          "idOrder": idOrder.toString(),
          "status": status.toString(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfRestaurantOrderDetails = jsonDecode(res.body);
        if (resBodyOfRestaurantOrderDetails['success']) {
          Fluttertoast.showToast(msg: "Status updated successfully!");
        } else {
          Fluttertoast.showToast(msg: "Not orders found.");
        }
      } else {
        print("Problema pe undeva ");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
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
            child: displayOrderListForRestaurant(context),
          ),
        ],
      ),
    );
  }

  Widget displayOrderListForRestaurant(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: getRecentOrderInformation(),
        builder: (context, AsyncSnapshot<List<Orders>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('No orders found yet.'),
            );
          }

          if (dataSnapshot.hasData && dataSnapshot.data!.isNotEmpty) {
            List<Orders> orderList = dataSnapshot.data!;
            print("orderList: ${dataSnapshot.data![1].selectedItmes}");

            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  Orders eachOrderData = orderList[index];
                  print("eachOrderList: ${eachOrderData}");
                  List<String> items = getSelectedItems(
                      eachOrderData); //eachOrderData.selectedItmes!.split("||");

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID #${eachOrderData.idOrder}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Total amount: ${eachOrderData.totalPrice}\$',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Products:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: items.map((item) {
                              return Text('- $item');
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Order booking details:',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            DateFormat("dd MMMM, yyyy")
                                .format(eachOrderData.bookingDateTime!),
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            DateFormat("hh:mm a")
                                .format(eachOrderData.bookingDateTime!),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Stepper(
                            currentStep: _index,
                            onStepCancel: (_index > 0 || _index < 2)
                                ? () {
                                    if (_index > 0) {
                                      setState(() {
                                        _index--;
                                      });
                                    }
                                  }
                                : null,
                            onStepContinue: _index < 2
                                ? () {
                                    setState(() {
                                      _index++; // Move to the next step
                                    });
                                  }
                                : null,
                            onStepTapped: (int index) {
                              setState(() {
                                _index = index; // Jump to the tapped step
                              });
                            },
                            steps: [
                              Step(
                                title: Text('New'),
                                content: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Update Status to Processing'),
                                ),
                                isActive: eachOrderData.status ==
                                    'new', // Conditionally activate step based on status
                              ),
                              Step(
                                title: Text('Processing'),
                                content: Text('Update Status to Done'),
                                isActive: eachOrderData.status ==
                                    'processing', // Conditionally activate step based on status
                              ),
                              Step(
                                title: Text('Done'),
                                content: Text('Order is Complete'),
                                isActive: eachOrderData.status ==
                                    'done', // Conditionally activate step based on status
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateStatusScreen()),
                              );
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'See More',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Nothing found.'),
            );
          }
        },
      ),
    );
  }
}
