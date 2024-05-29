import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/controllers/item_details_controller.dart';
import 'package:menu_app/repositories/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:menu_app/repositories/userPreferences/current_user.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Product? itemInfo;

  ItemDetailsScreen({
    this.itemInfo,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(CurrentUser());
  DateTime currentDateTime = DateTime.now();

  addItemToCart() async {
    try {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "idProduct": widget.itemInfo!.idProduct.toString(),
          "idRestaurant": widget.itemInfo!.idRestaurant.toString(),
          "idUser": currentOnlineUser.user.idUser.toString(),
          "quantity": itemDetailsController.quantity.toString(),
          "sizeCart": widget.itemInfo!.sizes![itemDetailsController.size],
        },
      );
      //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success']) {
          Fluttertoast.showToast(msg: "Product added to cart successfully");
        } else {
          Fluttertoast.showToast(msg: "Product couldn't be added to cart.");
        }
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

/*
  addOrder() async {
    try {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "idUser": currentOnlineUser.user.idUser.toString(),
          "idRestaurant": widget.itemInfo!.idRestaurant.toString(),
          "orderDateTime": currentDateTime.toString() ,
          "bookingDateTime": ,
          "numberOfPeople": ,
        },
      );
      //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success']) {
          Fluttertoast.showToast(msg: "Product added to cart successfully");
        } else {
          Fluttertoast.showToast(msg: "Product couldn't be added to cart.");
        }
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  addOrderDetails() async {
     try {
      var res = await http.post(
        Uri.parse(API.addOrderDetails),
        body: {
          "idProduct": widget.itemInfo!.idProduct.toString(),
          "idOrder": ,
          "quantity": itemDetailsController.quantity.toString(),
          "size": widget.itemInfo!.sizes![itemDetailsController.size],
        },
      );
      //daca am comunicat corect cu serverul raspunsul este 200 - s-a realizat conexiunea
      if (res.statusCode == 200) {
        var resBodyOfLogIn = jsonDecode(res.body);
        if (resBodyOfLogIn['success']) {
          Fluttertoast.showToast(msg: "Logged in successfully.");
          User userInfo = User.fromJson(resBodyOfLogIn["userData"]);
          //se salveaza informatiile utilizatorului in local storage cu SharedPreferences
          await RememberUserPrefs.storeUserInfo(userInfo);
          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(() => DashboardOfFragments());
          });
        } else {
          Fluttertoast.showToast(msg: "Incorrect credentials.");
        }
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // item image
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/Menu.png'),
            image: NetworkImage(widget.itemInfo!.imageUrl!),
            imageErrorBuilder: (context, error, stackTraceError) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),

          // item information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          )
        ],
      ),
    );
  }

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

            // item name
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

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // description

                // price

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // item rating + rating number
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
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
                            "(${widget.itemInfo!.rating!})",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // tags
                      Text(
                        "Tags: ${widget.itemInfo!.tags!.toString().replaceAll("[", "").replaceAll("]", "")}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // description
                      Text(
                        "Description: ${widget.itemInfo!.description}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // price
                      Text(
                        "${widget.itemInfo!.price}\$",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // item counter
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          itemDetailsController.setQuantityItem(
                              itemDetailsController.quantity + 1);
                        },
                      ),
                      Text(
                        itemDetailsController.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (itemDetailsController.quantity - 1 >= 1) {
                            itemDetailsController.setQuantityItem(
                                itemDetailsController.quantity - 1);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Quantity must be at least 1");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Text(
              "Select size: ",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.sizes!.length, (index) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      itemDetailsController.setSizeItem(index);
                    },
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: itemDetailsController.size == index
                              ? Colors.orangeAccent
                              : Colors.transparent,
                        ),
                        color: itemDetailsController.size == index
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.orangeAccent.withOpacity(0.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.itemInfo!.sizes![index]
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 30,
            ),

            // add to cart button
            Material(
              elevation: 5,
              color: Colors.orange,
              borderRadius: BorderRadius.circular(60),
              child: InkWell(
                onTap: () {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(60),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(color: Colors.white, fontSize: 15),
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
