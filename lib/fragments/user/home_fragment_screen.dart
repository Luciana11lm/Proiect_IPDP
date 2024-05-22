import 'package:flutter/material.dart';
import 'package:menu_app/models/restaurant.dart';

class HomeFragmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Restaurant'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
/*
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: 4, // Number of restaurant items to display
          itemBuilder: (context, index) {
            return Restaurant(
              imageUrl:
                  'assets/restaurant${index + 1}.jpg', // Placeholder for images
              name:
                  'Restaurant ${index + 1}', // Placeholder for restaurant name
              description:
                  'Description for Restaurant ${index + 1}', // Placeholder for description
            );
          },
        ),
      ),
    );
  }
}
*/