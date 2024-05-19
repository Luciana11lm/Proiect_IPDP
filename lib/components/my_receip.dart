import "package:flutter/material.dart";
import "package:menu_app/models/restaurant.dart";
import "package:provider/provider.dart";

class MyReceipt extends StatelessWidget {
  const MyReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Consumer<Restaurant>(
                builder: (context, restaurant, child) =>
                    Text(restaurant.displayCartReceipt()),
              ),
            )
          ],
        ));
  }
}
