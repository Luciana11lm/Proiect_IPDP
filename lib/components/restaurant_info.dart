import 'package:flutter/material.dart';

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Adress",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            child: Row(
              children: [
                const Text("Str Politehnicii nr 153"),
                Icon(Icons.location_on,
                    color: Theme.of(context).colorScheme.primary)
              ],
            ),
          )
        ],
      ),
    );
  }
}
