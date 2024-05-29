import 'package:flutter/material.dart';

class Order {
  int? idOrder;
  int? idUser;
  int? idRestaurant;
  DateTime? orderDateTime;
  DateTime? bookingDateTime;
  int? numberOfPeople;
  double? totalPrice;

  Order({
    this.idUser,
    this.idRestaurant,
    this.orderDateTime,
    this.bookingDateTime,
    this.numberOfPeople,
    this.totalPrice,
  });

// Method to create an Order object from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      //idOrder: json['idOrder'],
      idUser: json['idUser'],
      idRestaurant: json['idRestaurant'],
      orderDateTime: DateTime.parse(json['orderDateTime']),
      bookingDateTime: DateTime.parse(json['bookingDateTime']),
      numberOfPeople: json['numberOfPeople'],
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );
  }

  // Method to convert an Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idOrder': idOrder,
      'idUser': idUser,
      'idRestaurant': idRestaurant,
      'orderDateTime': orderDateTime?.toIso8601String(),
      'bookingDateTime': bookingDateTime?.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'totalPrice': totalPrice,
    };
  }
}
