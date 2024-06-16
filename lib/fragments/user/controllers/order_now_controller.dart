import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OrderNowController extends GetxController {
  RxBool _makeReservation = false.obs;
  RxInt _numberOfPeople = 0.obs;
  Rx<DateTime> _reservationDate = DateTime.now().obs;
  Rx<TimeOfDay> _reservationTime = TimeOfDay.now().obs;
  Rx<String> _reservationRestaurantName = RxString('');

  bool get makeReservation => _makeReservation.value;
  int get numberOfPeople => _numberOfPeople.value;
  DateTime get reservationDate => _reservationDate.value;
  TimeOfDay get reservationTime => _reservationTime.value;
  String get reservationRestaurantName => _reservationRestaurantName.value;

  setReservation(bool newReservation) {
    _makeReservation.value = newReservation;
  }

  setNumberOfPeople(int newNumberOfPeople) {
    _numberOfPeople.value = newNumberOfPeople;
  }

  void setReservationDate(DateTime newDate) {
    _reservationDate.value = newDate;
  }

  void setReservationTime(TimeOfDay newTime) {
    _reservationTime.value = newTime;
  }

  void setReservationRestaurantName(String newReservationRestaurantName) {
    _reservationRestaurantName.value = newReservationRestaurantName;
  }
}
