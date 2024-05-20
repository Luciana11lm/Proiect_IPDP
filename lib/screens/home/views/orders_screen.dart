import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
        ),
        titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 30),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(children: [
                  Text("Order number: 1",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 100,
                  ),
                  Text("Price: 10\$", style: TextStyle(fontSize: 16)),
                ]),
                Row(
                  children: [
                    Text("Food: ", style: TextStyle(fontSize: 14)),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
