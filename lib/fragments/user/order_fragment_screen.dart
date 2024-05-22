import 'package:flutter/material.dart';
import 'package:menu_app/repositories/models/order.dart';

class OrderFragmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.orange,
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