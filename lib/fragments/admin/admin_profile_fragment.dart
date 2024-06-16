import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/item/item_details_screen.dart';
import 'package:menu_app/repositories/models/product.dart';
import 'package:menu_app/repositories/restaurantPreferences/current_restaurant.dart';
import 'package:menu_app/repositories/userPreferences/user_preferences.dart';
import 'package:menu_app/screens/auth/sign_in_screen.dart';
import 'package:http/http.dart' as http;

class AdminProfileFragmentScreen extends StatelessWidget {
  final CurrentRestaurant _currentRestaurant = Get.put(CurrentRestaurant());

  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Log Out",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: const Text(
          "Are you sure\nyou want to log out?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      // remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(const SignInScreen());
      });
    }
  }

  Future<List<Product>> getTrendingProducts() async {
    List<Product> trendingProductsList = [];

    try {
      var res = await http.post(Uri.parse(API.getTrendingMostPopularProducts));
      if (res.statusCode == 200) {
        var responseBodyOfTrendingProducts = jsonDecode(res.body);
        if (responseBodyOfTrendingProducts["success"]) {
          (responseBodyOfTrendingProducts["itemsData"] as List)
              .forEach((eachRecord) {
            trendingProductsList.add(Product.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return trendingProductsList;
  }

  @override
  Widget build(BuildContext context) {
    String? name = _currentRestaurant.restaurant.name;
    String? description = _currentRestaurant.restaurant.description;
    String? city = _currentRestaurant.restaurant.city;
    String? street = _currentRestaurant.restaurant.street;
    String? number = _currentRestaurant.restaurant.number;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$name",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$description",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Most Bought Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            //
            trendingMostPopularItemWidget(context),

            const SizedBox(
              height: 20,
            ),
            Center(
              child: Material(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(60),
                child: InkWell(
                  onTap: () {
                    // functia de log out
                    signOutUser();
                  },
                  borderRadius: BorderRadius.circular(60),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text("Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget trendingMostPopularItemWidget(context) {
    return FutureBuilder(
      future: getTrendingProducts(),
      builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnapShot.data == null) {
          return const Center(child: Text("No trending item found"));
        }
        if (dataSnapShot.data!.length > 0) {
          return Container(
            height: 240,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Product eachProductData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ItemDetailsScreen(itemInfo: eachProductData));
                  },
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 10,
                        index == dataSnapShot.data!.length - 1 ? 16 : 8, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 2),
                          blurRadius: 8,
                          color: Color.fromARGB(255, 146, 146, 146),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: FadeInImage(
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage('assets/Menu.png'),
                            image: NetworkImage(eachProductData.imageUrl!),
                            imageErrorBuilder:
                                (context, error, stackTraceError) {
                              return const Center(
                                child: Icon(Icons.broken_image_outlined),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name and price of the item
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachProductData.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow
                                          .ellipsis, //textul extra din titlu e convertit in ...
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 11, 8, 8),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    eachProductData.price.toString() + "\$",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 105, 18, 18),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  // reating stars
                                  RatingBar.builder(
                                    initialRating:
                                        eachProductData.rating! * 0.5,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, c) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (updateRating) {},
                                    ignoreGestures: true,
                                    unratedColor:
                                        Color.fromARGB(255, 206, 205, 205),
                                    itemSize: 18,
                                  ),

                                  //rating number
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "(${eachProductData.rating!})",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, no data "),
          );
        }
      },
    );
  }
}
