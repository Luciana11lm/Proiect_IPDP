import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:menu_app/components/my_button.dart";
import "package:menu_app/models/food.dart";
import "package:menu_app/models/restaurant.dart";

class FoodScreen extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};
  FoodScreen({super.key, required this.food}) {
    for (Addon addon in food.availableAddons) {
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  void addToCart(Food food, Map<Addon, bool> selectedAddons) {
    Navigator.pop(context);

    List<Addon> currentlySelectedAddos = [];
    for (Addon addon in widget.food.availableAddons) {
      if (widget.selectedAddons[addon] == true) {
        currentlySelectedAddos.add(addon);
      }
    }
    context.read<Restaurant>().addToCart(food, currentlySelectedAddos);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(widget.food.imagePath),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "\$${widget.food.price}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.food.description),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Add-ons",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.tertiary),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: widget.food.availableAddons.length,
                          itemBuilder: (context, index) {
                            Addon addon = widget.food.availableAddons[index];
                            return CheckboxListTile(
                              title: Text(addon.name),
                              subtitle: Text("\$${addon.price}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              value: widget.selectedAddons[addon],
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.selectedAddons[addon] = value!;
                                });
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
              MyButton(
                onTap: () => addToCart(widget.food, widget.selectedAddons),
                text: "Add to cart",
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
      SafeArea(
        child: Opacity(
          opacity: 0.6,
          child: Container(
            margin: const EdgeInsets.only(left: 25),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    ]);
  }
}
