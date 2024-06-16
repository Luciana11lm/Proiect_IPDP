import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class OrderConfirmationController extends GetxController {
  RxString _reservationRestaurantName = RxString('');
  RxInt _numberOfPeople = 0.obs;
  Rx<DateTime> _reservationTime = DateTime.now().obs;

  String get reservationRestaurantName => _reservationRestaurantName.value;
  int get numberOfPeople => _numberOfPeople.value;
  DateTime get reservationDateTime => _reservationTime.value;

  setOrderDetails(String newReservationRestaurantName, int newNumberOfPeople,
      DateTime newReservationDateTime) {
    _reservationRestaurantName.value = newReservationRestaurantName;
    _numberOfPeople.value = newNumberOfPeople;
    _reservationTime.value = newReservationDateTime;
  }
}
