import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/controllers/cart_list_controller.dart';
import 'package:menu_app/repositories/models/cart.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];
    try {
      var res = await http.post(
        Uri.parse(API.getCartList),
        body: {
          "currentOnlineUserID": currentOnlineUser.user.idUser.toString(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserCartItems['success']) {
          (resBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItem));
          });
        } else {
          Fluttertoast.showToast(msg: "Error occurred");
        }
        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error :: " + errorMsg.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach(
        (itemInCart) {
          if (cartListController.selectedItemList
              .contains(itemInCart.idProduct)) {
            double eachItemTotalAmount = (itemInCart.price!) *
                (double.parse(itemInCart.quantity.toString()));
            cartListController
                .setTotal(cartListController.total + eachItemTotalAmount);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
