import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/controllers/cart_list_controller.dart';
import 'package:menu_app/fragments/user/item/item_details_screen.dart';
import 'package:menu_app/fragments/user/order/order_now_screen.dart';
import 'package:menu_app/repositories/models/cart.dart';
import 'package:menu_app/repositories/models/product.dart';
import 'package:menu_app/repositories/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final _currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    String userId = _currentOnlineUser.user.idUser.toString();
    List<Cart> cartListOfCurrentUser = [];
    try {
      print("Current user ID: ${userId}");
      var res = await http.post(
        Uri.parse(API.getCartList),
        body: {
          "currentOnlineUserID": userId,
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserCartItems = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserCartItems['success']) {
          (resBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItem) {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItem));
          });
        } else {
          Fluttertoast.showToast(msg: "Error occurred");
        }
        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error :: " + errorMsg.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach(
        (itemInCart) {
          if (cartListController.selectedItemList.contains(itemInCart.idCart)) {
            double eachItemTotalAmount = (itemInCart.price!) *
                (double.parse(itemInCart.quantity.toString()));
            cartListController
                .setTotal(cartListController.total + eachItemTotalAmount);
          }
        },
      );
    }
  }

  deleteSelectedItemsFromUserCartList(int cartId) async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteSelectedItemsFromCartList),
        body: {
          "idCart": cartId.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);
        if (responseBodyFromDeleteCart["success"] == true) {
          getCurrentUserCartList();
        }
      } else {
        Fluttertoast.showToast(msg: "Error: status Code is not 200");
      }
    } catch (errorMsg) {
      print("Error: " + errorMsg.toString());
    }
  }

  updateQuantityInCart(int cartID, int newQuantity) async {
    try {
      var res = await http.post(
        Uri.parse(API.updateItemInCartList),
        body: {
          "idCart": cartID.toString(),
          "quantity": newQuantity.toString(),
        },
      );
      if (res.statusCode == 200) {
        var responseBodyOfUpdateQuantity = jsonDecode(res.body);
        if (responseBodyOfUpdateQuantity["success"] == true) {
          getCurrentUserCartList();
        }
      } else {
        Fluttertoast.showToast(msg: "Error: status Code is not 200");
      }
    } catch (errorMsg) {
      print("Error: " + errorMsg.toString());
    }
  }

/*
  placeOrderNow(List<Map<String, dynamic>>? selectedCartListItemsInfo) async {
    try {
      var response = await http.post(
        Uri.parse(API.placeDetailsOrder),
        body: {
          "idUser": selectedCartListItemsInfo?["idUser"].toString();
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success']) {
          Fluttertoast.showToast(msg: "Order in process...");
          addOrderDetailsToBD(selectedCartListItemsInfo);
        } else {
          Fluttertoast.showToast(msg: "Order could not be placed");
        }
      }
    } catch (errorMsg) {
      print("Error ::" + errorMsg.toString());
    }
  }

  addOrderDetailsToBD(
      List<Map<String, dynamic>>? selectedCartListItemsInfo) async {
    try {
      var response = await http.post(
        Uri.parse(API.placeOrder),
        body: {},
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success']) {
          Fluttertoast.showToast(msg: "Order placed successfully!");
          addOrderDetailsToBD(selectedCartListItemsInfo);
        } else {
          Fluttertoast.showToast(msg: "Order could not be placed");
        }
      }
    } catch (errorMsg) {
      print("Error ::" + errorMsg.toString());
    }
  }

  */
  List<Map<String, dynamic>> getSelectedCartListItemsInformation() {
    List<Map<String, dynamic>> selectedCartListItemsInformation = [];
    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach(
        (selectedCartListItem) {
          if (cartListController.selectedItemList
              .contains(selectedCartListItem.idCart)) {
            Map<String, dynamic> itemInformation = {
              "idProduct": selectedCartListItem.idProduct,
              "name": selectedCartListItem.name,
              "imageUrl": selectedCartListItem.imageUrl,
              "price": selectedCartListItem.price!,
              "idRestaurant": selectedCartListItem.idRestaurant,
              "quantity": selectedCartListItem.quantity,
              "size": selectedCartListItem.sizeCart,
              "totalAmount":
                  selectedCartListItem.price! * selectedCartListItem.quantity!,
            };
            selectedCartListItemsInformation.add(itemInformation);
          }
        },
      );
    }
    return selectedCartListItemsInformation;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "My Cart",
        ),
        actions: [
          //select all items in user's cart
          Obx(
            () => IconButton(
              onPressed: () {
                cartListController.setIsSelectedAllItems();
                cartListController.clearAllSelectedItems();
                if (cartListController.isSelectedAll) {
                  cartListController.cartList.forEach(
                    (eachItem) {
                      cartListController.addSelectedItem(eachItem.idCart!);
                    },
                  );
                }
                calculateTotalAmount();
              },
              icon: Icon(cartListController.isSelectedAll
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              color: cartListController.isSelectedAll
                  ? Colors.orange
                  : Colors.grey,
            ),
          ),

          //delete select items in user's cart
          GetBuilder(
            init: CartListController(),
            builder: (c) {
              if (cartListController.selectedItemList.length > 0) {
                return IconButton(
                  onPressed: () async {
                    var responseFromDialogBox = await Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.white70,
                        title: Text("Delete "),
                        content: const Text(
                            "Are you sure you want to delete\n selected product from you cart?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back(result: "yesDelete");
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (responseFromDialogBox == "yesDelete") {
                      cartListController.selectedItemList.forEach(
                        (eachSelectedItemUserCartItemId) {
                          //delete selected items now
                          deleteSelectedItemsFromUserCartList(
                              eachSelectedItemUserCartItemId);
                        },
                      );
                    }
                    calculateTotalAmount();
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    size: 30,
                    color: Colors.orangeAccent,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Obx(
        () => cartListController.cartList.length > 0
            ? ListView.builder(
                itemCount: cartListController.cartList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  // se pune in cartModel ficare element din lista de obiecte din cart
                  Cart cartModel = cartListController.cartList[index];
                  Product productModel = Product(
                      idProduct: cartModel.idProduct,
                      name: cartModel.name,
                      price: cartModel.price,
                      ingredients: cartModel.ingredients,
                      description: cartModel.description,
                      imageUrl: cartModel.imageUrl,
                      rating: cartModel.rating,
                      tags: cartModel.tags,
                      idRestaurant: cartModel.idProduct,
                      sizes: cartModel.sizes);
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        //check box
                        GetBuilder(
                          init: CartListController(),
                          builder: (c) {
                            return IconButton(
                              onPressed: () {
                                if (cartListController.selectedItemList
                                    .contains(cartModel.idCart)) {
                                  cartListController
                                      .deleteSelectedItem(cartModel.idCart!);
                                } else {
                                  cartListController
                                      .addSelectedItem(cartModel.idCart!);
                                }

                                calculateTotalAmount();
                              },
                              icon: Icon(
                                cartListController.selectedItemList
                                        .contains(cartModel.idCart)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: cartListController.isSelectedAll
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            );
                          },
                        ),
                        //product details
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  ItemDetailsScreen(itemInfo: productModel));
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0,
                                  index == 0 ? 16 : 8,
                                  16,
                                  index ==
                                          cartListController.cartList.length - 1
                                      ? 16
                                      : 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 6,
                                      color: Colors.grey)
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // name of the product
                                          Text(
                                            productModel.name.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400),
                                          ),

                                          const SizedBox(
                                            height: 20,
                                          ),

                                          // size and price
                                          Row(
                                            children: [
                                              // size
                                              Expanded(
                                                child: Text(
                                                  "Size: ${cartModel.sizeCart!.replaceAll("[", "").replaceAll("]", "")}",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),

                                              // price
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12, right: 12),
                                                child: Text(
                                                  "Price: ${cartModel.price.toString()}\$",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // + -

                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // -
                                              IconButton(
                                                onPressed: () {
                                                  // decrement
                                                  if (cartModel.quantity! - 1 >=
                                                      1) {
                                                    updateQuantityInCart(
                                                        cartModel.idCart!,
                                                        cartModel.quantity! -
                                                            1);
                                                  }
                                                },
                                                icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.grey,
                                                    size: 30),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),

                                              Text(
                                                cartModel.quantity.toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),

                                              // +
                                              IconButton(
                                                onPressed: () {
                                                  // increment
                                                  updateQuantityInCart(
                                                      cartModel.idCart!,
                                                      cartModel.quantity! + 1);
                                                },
                                                icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.grey,
                                                    size: 30),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  // display product's image

                                  Container(
                                    margin: const EdgeInsets.all(13),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      child: FadeInImage(
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            const AssetImage('assets/Menu.png'),
                                        image: NetworkImage(
                                            productModel.imageUrl!),
                                        imageErrorBuilder:
                                            (context, error, stackTraceError) {
                                          return const Center(
                                            child: Icon(
                                                Icons.broken_image_outlined),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(child: Text("Cart is empty")),
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c) {
          return Container(
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, -3), color: Colors.grey, blurRadius: 6)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // total amount
                const Text(
                  "   Total amount: ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 4,
                ),

                Obx(
                  () => Text(
                    cartListController.total.toStringAsFixed(2) + "\$",
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                //const SizedBox(width: 25,),
                Spacer(),

                Material(
                  color: cartListController.selectedItemList.length > 0
                      ? Colors.orange
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(60),
                  child: InkWell(
                      onTap: () {
                        cartListController.selectedItemList.length > 0
                            ? /*Get.to(
                                OrderNowScreen(
                                    selectedCartListItemsInfo:
                                        getSelectedCartListItemsInformation(),
                                    totalAmount: cartListController.total,
                                    selectedCartIDs:
                                        cartListController.selectedItemList),
                              )*/
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderNowScreen(
                                        selectedCartListItemsInfo:
                                            getSelectedCartListItemsInformation(),
                                        totalAmount: cartListController.total,
                                        selectedCartIDs: cartListController
                                            .selectedItemList)),
                              )
                            : null;
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          "Order now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
