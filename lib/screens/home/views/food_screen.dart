import "package:flutter/material.dart";
import "package:menu_app/models/food.dart";

class FoodScreen extends StatefulWidget {
  final Food food;
  const FoodScreen({super.key, required this.food});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            widget.food.imagePath,
            
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.food.name),
                Text(widget.food.description),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.food.availableAddons.length,
                    itemBuilder: (context, index) {
                      Addon addon = widget.food.availableAddons[index];
                      return CheckboxListTile(
                        title: Text(addon.name),
                        subtitle: Text(addon.price.toString()),
                        value: false,
                        onChanged: (value) {},
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
