import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menu_app/fragments/user/controllers/item_details_controller.dart';
import 'package:menu_app/repositories/models/restaurant.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant? itemInfo;

  RestaurantDetailsScreen({
    this.itemInfo,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final _currentOnlineUser = Get.put(CurrentUser());
  //DateTime currentDateTime = DateTime.now();

  //---------------------------------------------------------------
  //                         Widgets for UI
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // restaurant's image
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/Menu.png'),
            image: NetworkImage(widget.itemInfo!.imageRestaurantUrl!),
            imageErrorBuilder: (context, error, stackTraceError) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),

          // go back button
          Positioned(
            top: 45,
            left: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(60),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // product's information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          )
        ],
      ),
    );
  }

  // widget to display restaurant's information
  Widget itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 20,
            color: Color.fromARGB(255, 147, 147, 147),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 6,
                width: 140,
                decoration: BoxDecoration(
                    color: Color.fromARGB(137, 249, 141, 10),
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // restaurant's name
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow
                  .ellipsis, //textul extra din titlu e convertit in ...
              style: const TextStyle(
                  color: Color.fromARGB(217, 136, 129, 129),
                  fontSize: 25,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(
              height: 10,
            ),

            // description
            Text(
              "Description: ${widget.itemInfo!.description}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "Location: ${widget.itemInfo!.city}, ${widget.itemInfo!.street}, number. ${widget.itemInfo!.number}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),

            const SizedBox(
              height: 20,
            ),

            // add to cart button
            Center(
              child: Material(
                elevation: 5,
                color: Colors.orange,
                borderRadius: BorderRadius.circular(60),
                child: InkWell(
                  onTap: () {
                    // de implementat make reservation
                  },
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 180,
                    child: const Text(
                      "Make a reservation",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
