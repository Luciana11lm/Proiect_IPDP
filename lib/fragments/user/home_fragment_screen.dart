import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/item/item_details_screen.dart';
import 'package:menu_app/repositories/models/product.dart';
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
          allProducts(context),
        ],
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {},
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
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.orangeAccent,
            ),
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
                                    eachProductData.price.toString(),
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
                                    initialRating: eachProductData.rating!,
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
                                    unratedColor: Colors.white,
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
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name and price of the item
                              Row(
                                children: [
                                  //name
                                  Expanded(
                                    child: Text(
                                      eachProductRecord.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  //price
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: Text(
                                      eachProductRecord.price.toString() + "\$",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),

                              //tags
                              Text(
                                "Tags: ${eachProductRecord.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // image product
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          height: 90,
                          width: 90,
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
