import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/cart/cart_list_screen.dart';
import 'package:menu_app/fragments/user/item/item_details_screen.dart';
import 'package:menu_app/fragments/user/item/restaurant_details_screen.dart';
import 'package:menu_app/fragments/user/item/search_items.dart';
import 'package:menu_app/repositories/models/product.dart';
import 'package:menu_app/repositories/models/restaurant.dart';
import 'package:http/http.dart' as http;

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

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

  Future<List<Restaurant>> getRestaurants() async {
    List<Restaurant> RestaurantsList = [];

    try {
      var res = await http.post(Uri.parse(API.restaurantsList));
      if (res.statusCode == 200) {
        var responseBodyOfRestaurants = jsonDecode(res.body);
        if (responseBodyOfRestaurants["success"]) {
          (responseBodyOfRestaurants["itemsData"] as List)
              .forEach((eachRecord) {
            RestaurantsList.add(Restaurant.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return RestaurantsList;
  }

  Future<List<Product>> getAllProducts() async {
    List<Product> allProductsList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllProducts));
      if (res.statusCode == 200) {
        var responseBodyOfAllProducts = jsonDecode(res.body);
        if (responseBodyOfAllProducts["success"]) {
          (responseBodyOfAllProducts["itemsData"] as List)
              .forEach((eachRecord) {
            allProductsList.add(Product.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return allProductsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  "What are you going\n to eat today?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              // cart icon
              Positioned(
                top: 45,
                right: 7,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 253, 229, 188).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.orange,
                    onPressed: () {
                      Get.to(CartListScreen());
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          // serach bar widget
          showSearchBarWidget(),
          // popular products
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Popular products",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 24,
              ),
            ),
          ),

          trendingMostPopularItemWidget(context),
          const SizedBox(
            height: 16,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Restaurants",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 24,
              ),
            ),
          ),
          // all new restaurants
          displayRestaurants(context),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Discover products",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 24,
              ),
            ),
          ),
          // all products
          allProducts(context),
        ],
      ),
    );
  }

  // search bar widget
  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextField(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.orangeAccent,
            ),
          ),
          hintText: "Search your favourite food...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.orange,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide(
              width: 2,
              color: Color.fromARGB(193, 253, 240, 218),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide(
              width: 2,
              color: Colors.orange,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  // widget to display cards with trending products
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

  // widget to diplay restaurants
  Widget displayRestaurants(context) {
    return FutureBuilder(
      future: getRestaurants(),
      builder: (context, AsyncSnapshot<List<Restaurant>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnapShot.data == null) {
          return const Center(child: Text("No restaurant found"));
        }
        if (dataSnapShot.data!.length > 0) {
          return Container(
            height: 240,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Restaurant eachRestaurantData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        RestaurantDetailsScreen(itemInfo: eachRestaurantData));
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
                            placeholder: const AssetImage('assets/r3.jpeg'),
                            image: AssetImage('assets/r3.jpeg'),
                            /*NetworkImage(
                                eachRestaurantData.imageRestaurantUrl!)*/
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
                                      textAlign: TextAlign.center,
                                      eachRestaurantData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow
                                          .ellipsis, //textul extra din titlu e convertit in ...
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 11, 8, 8),
                                        fontSize: 12, // Mărimea fontului
                                        fontWeight: FontWeight
                                            .normal, // Lăsăm fontWeight normal pentru fontul Pacifico
                                        letterSpacing:
                                            1, // Spațiere între litere
                                        shadows: [
                                          Shadow(
                                            offset: Offset(
                                                1.0, 1.0), // Umbra textului
                                            blurRadius: 2.0,
                                            color:
                                                Color.fromARGB(64, 176, 38, 38),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
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

  // widget to display all products
  Widget allProducts(context) {
    return FutureBuilder(
      future: getAllProducts(),
      builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnapShot.data == null) {
          return const Center(child: Text("No trending item found"));
        }
        if (dataSnapShot.data!.length > 0) {
          return ListView.builder(
            itemCount: dataSnapShot.data!.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Product eachProductRecord = dataSnapShot.data![index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ItemDetailsScreen(itemInfo: eachProductRecord));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == dataSnapShot.data!.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        color: Color.fromARGB(255, 146, 146, 146),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          height: 123,
                          width: 120,
                          fit: BoxFit.cover,
                          placeholder: const AssetImage('assets/Menu.png'),
                          image: NetworkImage(eachProductRecord.imageUrl!),
                          imageErrorBuilder: (context, error, stackTraceError) {
                            return const Center(
                              child: Icon(Icons.broken_image_outlined),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Numele și prețul produsului
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Nume
                                  Expanded(
                                    child: Text(
                                      eachProductRecord.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Preț
                                  Text(
                                    '${eachProductRecord.price!.toStringAsFixed(2)}\$',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 105, 18, 18),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),

                              // Ingrediente
                              Text(
                                "Ingredients: ${eachProductRecord.ingredients.toString().replaceAll("[", "").replaceAll("]", "")}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 3),

                              // Tags
                              Text(
                                "Tags: ${eachProductRecord.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
