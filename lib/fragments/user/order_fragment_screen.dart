import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:menu_app/fragments/user/home_fragment_screen.dart';
import 'package:menu_app/repositories/models/order.dart';

class OrderFragmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
    );
  }
}
  /*
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: 5, // Number of orders to display
          itemBuilder: (context, index) {
            return Order(
              imageUrl:
                  'assets/product${index + 1}.jpg', // Placeholder for product images
              productName:
                  'Product ${index + 1}', // Placeholder for product name
              price: '\$${(index + 1) * 10}', // Placeholder for price
              orderStatus: 'Status: Delivered', // Placeholder for order status
            );
          },
        ),
      ),
    );
  }
}
*/