import 'package:flutter/material.dart';
import 'package:menu_app/components/my_button.dart';
import 'package:menu_app/components/my_cart_tile.dart';
import 'package:menu_app/models/cart_items.dart';
import 'package:menu_app/models/restaurant.dart';
import 'package:menu_app/screens/home/views/checkout_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(builder: (context, restaurant, child) {
      final userCart = restaurant.cart;
      return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Are you sure you want to clear the cart?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            restaurant.clearCart();
                          },
                          child: Text("Yes"),
                        )
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  userCart.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text("Cart is empty"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: userCart.length,
                            itemBuilder: (context, index) {
                              final cartItem = userCart[index];
                              return MyCartTile(cartItem: cartItem);
                            },
                          ),
                        )
                ],
              ),
            ),
            MyButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen())), text: "Go to checkout"),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      );
    });
  }
}
