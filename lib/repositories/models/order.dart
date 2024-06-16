import 'package:flutter/cupertino.dart';

class Orders {
  int? idOrder;
  int? idUser;
  int? idRestaurant;
  String? selectedItmes;
  DateTime? orderDateTime;
  DateTime? bookingDateTime;
  int? numberOfPeople;
  double? totalPrice;
  String? status;

  Orders({
    this.idUser,
    this.idRestaurant,
    this.selectedItmes,
    this.orderDateTime,
    this.bookingDateTime,
    this.numberOfPeople,
    this.totalPrice,
    this.status,
  });

  Orders.WithId({
    this.idOrder,
    this.idUser,
    this.idRestaurant,
    this.selectedItmes,
    this.orderDateTime,
    this.bookingDateTime,
    this.numberOfPeople,
    this.totalPrice,
    this.status,
  });

// Method to create an Order object from JSON
  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders.WithId(
      idOrder: int.parse(json['idOrder']),
      idUser: int.parse(json['idUser']),
      idRestaurant: int.parse(json['idRestaurant']),
      selectedItmes: json['selectedItmes'],
      orderDateTime: DateTime.parse(json['orderDateTime']),
      bookingDateTime: DateTime.parse(json['bookingDateTime']),
      numberOfPeople: int.parse(json['numberOfPeople']),
      totalPrice: json['totalPrice'] != null
          ? (json['totalPrice'] is String
              ? double.parse(json['totalPrice'])
              : (json['totalPrice'] as num).toDouble())
          : null,
    );
  }

  // Method to convert an Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser.toString(),
      'idRestaurant': idRestaurant.toString(),
      'selectedItems': selectedItmes,
      'bookingDateTime': bookingDateTime?.toIso8601String(),
      'numberOfPeople': numberOfPeople.toString(),
      'totalPrice': totalPrice!.toStringAsFixed(2),
      'status': status,
    };
  }
}
