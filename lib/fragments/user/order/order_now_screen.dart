import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/controllers/order_now_controller.dart';
import 'package:menu_app/fragments/user/order/order_confirmation.dart';
import 'package:menu_app/repositories/models/order.dart';
import 'package:menu_app/repositories/models/restaurant.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;

  CurrentUser currentUser = Get.put(CurrentUser());

  final OrderNowController orderNowController = Get.put(OrderNowController());
  final List<String> reservationOptions = ["Yes", "No"];
  int numberOfPeopleSelected = 1;
  int selectedRestaurantId = 1;
  List<String> listOfRestaurantsName = [];
  List<String> listOfRestaurantsIds = [];

  OrderNowScreen({
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  }) {
    initializeListOfRestaurants();
  }

  // method to get a list of restaurant's id from each item to be ordered and call the function to get it's name from tabel
  void initializeListOfRestaurants() async {
    listOfRestaurantsIds = selectedCartListItemsInfo!
        .map((selectedItem) => selectedItem['idRestaurant'].toString())
        .toSet()
        .toList();

    print(listOfRestaurantsIds.length);

    listOfRestaurantsIds.forEach(
        (idRestaurantToGetName) => getRestaurantsNames(idRestaurantToGetName));
  }

  // method to get restaurant name from tabel
  getRestaurantsNames(String selectedRestaurantIdSearchedInDb) async {
    try {
      var res = await http.post(
        Uri.parse(API.getOneRestaurant),
        body: {
          "idRestaurant":
              int.parse(selectedRestaurantIdSearchedInDb.trim()).toString(),
        },
      );
      //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      if (res.statusCode == 200) {
        var resBodyOfLogIn = jsonDecode(res.body);
        if (resBodyOfLogIn['success']) {
          Restaurant restaurantInfo =
              Restaurant.fromJson(resBodyOfLogIn["restaurantData"]);
          //se salveaza informatiile restaurantului in local storage cu SharedPreferences
          listOfRestaurantsName.add(restaurantInfo.name.toString());
          print(restaurantInfo.name);
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

  // method for verifying if selected time is after 9am and before 8pm
  bool _isTimeWithinRange(
      TimeOfDay time, TimeOfDay minTime, TimeOfDay maxTime) {
    int selectedMinutes = time.hour * 60 + time.minute;
    int minMinutes = minTime.hour * 60 + minTime.minute;
    int maxMinutes = maxTime.hour * 60 + maxTime.minute;

    return selectedMinutes >= minMinutes && selectedMinutes <= maxMinutes;
  }

  DateTime getCombinedDateTime() {
    return DateTime(
      orderNowController.reservationDate.year,
      orderNowController.reservationDate.month,
      orderNowController.reservationDate.day,
      orderNowController.reservationTime.hour,
      orderNowController.reservationTime.minute,
    );
  }

  deleteSelectedItemsFromUserCartList(int cartId) async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteSelectedItemsFromCartList),
        body: {
          "idCart": cartId.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);
        if (responseBodyFromDeleteCart["success"] == true) {
          Fluttertoast.showToast(
              msg: 'Your new order has been placed successfully!');
        }
      } else {
        Fluttertoast.showToast(msg: "Error: status Code is not 200");
      }
    } catch (errorMsg) {
      print("Error: " + errorMsg.toString());
    }
  }

  saveNewOrderInfo(BuildContext context) async {
    String selectedItmesString = selectedCartListItemsInfo!
        .map((eachSelectedItem) => jsonEncode(eachSelectedItem))
        .toList()
        .join("||");
    print('Selected restaurant ID to save: $selectedRestaurantId');
    Orders order = Orders(
      idUser: currentUser.user.idUser,
      idRestaurant: selectedRestaurantId,
      selectedItmes: selectedItmesString,
      bookingDateTime: getCombinedDateTime(),
      numberOfPeople: orderNowController.numberOfPeople,
      totalPrice: totalAmount,
      status: 'new',
    );

    try {
      var res = await http.post(
        Uri.parse(API.saveOrder),
        body: order.toJson(),
      );

      if (res.statusCode == 200) {
        var resBodyOfAddNewOrder = jsonDecode(res.body);
        if (resBodyOfAddNewOrder["success"] == true) {
          // delete ordered items from cart
          selectedCartIDs!.forEach((eachSelectedItemCartId) {
            deleteSelectedItemsFromUserCartList(eachSelectedItemCartId);
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderConfirmationScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: 'Order not placed');
        }
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  // method to get the restaurant from the list of restaurant that sell the products in cart
  void showRestaurantPickerDialog(BuildContext context) {
    int selectedIndex = 0;
    orderNowController
        .setReservationRestaurantName(listOfRestaurantsName[selectedIndex]);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          child: CupertinoPicker(
            itemExtent: 40,
            onSelectedItemChanged: (int index) {
              selectedIndex = index;
              selectedRestaurantId = int.tryParse(listOfRestaurantsIds[index])!;
              orderNowController
                  .setReservationRestaurantName(listOfRestaurantsName[index]);
              print('selectedRestaurantId= $selectedRestaurantId');
            },
            children: listOfRestaurantsName
                .map((restaurantName) {
                  return Text(
                    restaurantName,
                    style: TextStyle(fontSize: 16),
                  );
                })
                .toSet()
                .toList(),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        selectedRestaurantId =
            int.tryParse(listOfRestaurantsIds[selectedIndex]) ?? 0;
        orderNowController
            .setReservationRestaurantName(listOfRestaurantsName[selectedIndex]);
      }
    });
  }

  // method to get hour of booking form dialog
  void showTimePickerDialog(BuildContext context) {
    DateTime now = DateTime.now();
    bool isToday = now.day == orderNowController.reservationDate.day &&
        now.month == orderNowController.reservationDate.month &&
        now.year == orderNowController.reservationDate.year;
    TimeOfDay minTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay maxTime = TimeOfDay(hour: 20, minute: 0);

    if (isToday) {
      int currentHour = now.hour;
      int currentMinute = now.minute;
      int nextHour = currentMinute > 30 ? currentHour + 1 : currentHour;
      int nextMinute = (currentMinute + 30) % 60;
      minTime = TimeOfDay(hour: nextHour, minute: nextMinute);
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          child: CupertinoDatePicker(
            initialDateTime:
                isToday ? now : DateTime(now.year, now.month, now.day, 9),
            minimumDate: DateTime(
                now.year, now.month, now.day, minTime.hour, minTime.minute),
            maximumDate: DateTime(
                now.year, now.month, now.day, maxTime.hour, maxTime.minute),
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (pickedTime) {
              TimeOfDay selectedTime = TimeOfDay.fromDateTime(pickedTime);
              if (_isTimeWithinRange(selectedTime, minTime, maxTime)) {
                orderNowController.setReservationTime(selectedTime);
              } else {
                Fluttertoast.showToast(msg: 'Invalid time');
              }
            },
          ),
        );
      },
    );
  }

  // method for formatting the reservation date
  String _formatTimeOfDay(TimeOfDay time) {
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    int hour = time.hourOfPeriod;
    int minute = time.minute;

    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    return '$hourStr:$minuteStr $period';
  }

  // method to get Date from dialog
  void showDatePickerDialog(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime minimumDate = now.hour >= 20 ? now.add(Duration(days: 1)) : now;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          child: CupertinoDatePicker(
            initialDateTime: minimumDate,
            minimumDate: minimumDate,
            maximumYear: 2025,
            minimumYear: DateTime.now().year,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (pickedDate) {
              orderNowController.setReservationDate(pickedDate);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Summary and Reservation'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Order Summary Section
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // display order components
          displaySelectedItemsFromUserCart(),
          const SizedBox(height: 10),

          // reservation section
          const Divider(
            thickness: 0.3,
            color: Colors.grey,
            indent: 5,
            endIndent: 5,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Total Amount: \$${totalAmount ?? 0}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 80, 2, 2)),
            ),
          ),
          const SizedBox(height: 20),

          // Reservation Option Section
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Would you like to make a reservation?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      !orderNowController.makeReservation
                          ? Colors.white70
                          : Colors.orange,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                  onPressed: () {
                    orderNowController.setReservation(true);
                  },
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      orderNowController.makeReservation
                          ? Colors.white70
                          : Colors.orange,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                  onPressed: () {
                    orderNowController.setReservation(false);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Reservation Details Section
          Obx(() {
            if (orderNowController.makeReservation) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 0.3,
                    color: Colors.grey,
                    indent: 5,
                    endIndent: 5,
                  ),

                  const Text(
                    'Select Restaurant:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // widget for selecting the date of the reservation
                  selectRestaurant(context),

                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 0.3,
                    color: Colors.grey,
                    indent: 5,
                    endIndent: 5,
                  ),

                  const Text(
                    'Select Date:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // widget for selecting the date of the reservation
                  selectReservationDate(context),

                  const SizedBox(height: 10),

                  const Divider(
                    thickness: 0.3,
                    color: Colors.grey,
                    indent: 5,
                    endIndent: 5,
                  ),

                  const Text(
                    'Select Time:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  // widget for selecting the date of the reservation
                  selectReservationTime(context),

                  const SizedBox(height: 10),

                  const Divider(
                    thickness: 0.3,
                    color: Colors.grey,
                    indent: 5,
                    endIndent: 5,
                  ),

                  const Text(
                    'How many people?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // widget for selecting the number of people using + and -
                  selectNumberOfPeople(),

                  const SizedBox(height: 10),
                ],
              );
            } else {
              return Container();
            }
          }),

          // Place Order Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  saveNewOrderInfo(context);
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 76, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Place Order: ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        totalAmount!.toStringAsFixed(2) + "\$",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displaySelectedItemsFromUserCart() {
    if (selectedCartListItemsInfo!.isEmpty) {
      return const Center(
        child: Text('No items in your cart'),
      );
    }
    return Column(
      children: List.generate(
        selectedCartListItemsInfo!.length,
        (index) {
          Map<String, dynamic> eachSelectedItem =
              selectedCartListItemsInfo![index];
          return Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                index == selectedCartListItemsInfo!.length - 1 ? 16 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 6,
                  color: Colors.grey,
                )
              ],
            ),
            child: Row(
              children: [
                // image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: FadeInImage(
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/Menu.png'),
                    image: NetworkImage(eachSelectedItem["imageUrl"]),
                    imageErrorBuilder: (context, error, stackTraceError) {
                      return const Center(
                        child: Icon(Icons.broken_image_outlined),
                      );
                    },
                  ),
                ),

                //name
                //quantity

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        // name
                        Text(
                          eachSelectedItem["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        // size
                        Row(
                          children: [
                            Text(
                              eachSelectedItem["size"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),

                            const Spacer(),

                            //quantity
                            Text(
                              'Quantity: ${eachSelectedItem["quantity"].toString()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        //total amount
                        Text(
                          'Total: \$${eachSelectedItem["totalAmount"].toString()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 80, 2, 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget selectNumberOfPeople() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // -
        IconButton(
          onPressed: () {
            // decrement
            if (numberOfPeopleSelected - 1 == 0) {
              Fluttertoast.showToast(msg: "Minimum number of people is 1");
            } else if (numberOfPeopleSelected - 1 >= 1) {
              numberOfPeopleSelected = numberOfPeopleSelected - 1;
              orderNowController.setNumberOfPeople(numberOfPeopleSelected);
            }
          },
          icon: const Icon(Icons.remove_circle_outline,
              color: Colors.orange, size: 35),
        ),
        const SizedBox(
          width: 10,
        ),

        Text(
          orderNowController.numberOfPeople.toString(),
          style: const TextStyle(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          width: 10,
        ),

        // +
        IconButton(
          onPressed: () {
            // increment
            if (numberOfPeopleSelected + 1 > 20) {
              Fluttertoast.showToast(msg: "Maximum number of people is 20");
            } else {
              numberOfPeopleSelected = numberOfPeopleSelected + 1;
              orderNowController.setNumberOfPeople(numberOfPeopleSelected);
            }
          },
          icon: const Icon(Icons.add_circle_outline,
              color: Colors.orange, size: 35),
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.people_alt_outlined,
          size: 30,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget selectReservationDate(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDatePickerDialog(context);
      },
      child: Row(
        children: [
          const Text(
            'Reservation',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Obx(
            () {
              DateTime now = DateTime.now();
              DateTime reservationDate = orderNowController.reservationDate;
              String dateString = reservationDate.day == now.day &&
                      reservationDate.month == now.month &&
                      reservationDate.year == now.year
                  ? 'Today, ${DateFormat('MMM d').format(reservationDate)}'
                  : DateFormat('EEE, MMM d').format(reservationDate);

              return Text(
                dateString,
                style: const TextStyle(color: Color(0xFFe36414)),
              );
            },
          ),
          const Icon(
            Icons.keyboard_arrow_right_outlined, // Right arrow icon
            size: 30,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget selectReservationTime(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTimePickerDialog(context);
      },
      child: Row(
        children: [
          const Text(
            'Time',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Obx(
            () {
              TimeOfDay reservationTime = orderNowController.reservationTime;
              String timeString = _formatTimeOfDay(reservationTime);
              return Text(
                timeString,
                style: const TextStyle(color: Color(0xFFe36414)),
              );
            },
          ),
          const Icon(
            Icons.keyboard_arrow_right_outlined, // Right arrow icon
            size: 30,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget selectRestaurant(BuildContext context) {
    print(orderNowController.reservationRestaurantName);
    return GestureDetector(
      onTap: () {
        showRestaurantPickerDialog(context);
      },
      child: Row(
        children: [
          const Text(
            'Selected Restaurant',
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              orderNowController.reservationRestaurantName,
              style: const TextStyle(color: Color(0xFFe36414)),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right_outlined, // Right arrow icon
            size: 30,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
