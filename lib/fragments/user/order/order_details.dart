import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menu_app/repositories/models/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Orders? clickedOrderInfo;

  const OrderDetailsScreen({this.clickedOrderInfo});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<String> getSelectedItems(Orders order) {
    return order.selectedItmes?.split('||') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a ")
              .format(widget.clickedOrderInfo!.bookingDateTime!),
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                      color: widget.clickedOrderInfo!.status == "new"
                          ? Colors.orange
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                      color: widget.clickedOrderInfo!.status == "preparing"
                          ? Colors.orange
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                      color: widget.clickedOrderInfo!.status == "done"
                          ? Colors.orange
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
              // display items belongs to clicked order
              displayClickedOrderItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayClickedOrderItems() {
    List<String>? clickedOrderItemsInfo =
        getSelectedItems(widget.clickedOrderInfo!);
    // widget.clickedOrderInfo!.selectedItmes!.split("||");

    if (clickedOrderItemsInfo.isEmpty) {
      return const Center(
        child: Text('No items in your cart'),
      );
    }

    return Column(
      children: List.generate(
        clickedOrderItemsInfo.length,
        (index) {
          Map<String, dynamic> itemInfo =
              jsonDecode(clickedOrderItemsInfo[index]);
          return Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                index == clickedOrderItemsInfo.length - 1 ? 16 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 6,
                  color: Colors.grey,
                )
              ],
            ),
            child: Row(
              children: [
                // image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: FadeInImage(
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/Menu.png'),
                    image: NetworkImage(itemInfo["imageUrl"]),
                    imageErrorBuilder: (context, error, stackTraceError) {
                      return const Center(
                        child: Icon(Icons.broken_image_outlined),
                      );
                    },
                  ),
                ),

                //name
                //quantity

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        // name
                        Text(
                          itemInfo["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        // size
                        Row(
                          children: [
                            Text(
                              itemInfo["size"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),

                            const Spacer(),

                            //quantity
                            Text(
                              'Quantity: ${itemInfo["quantity"].toString()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        //total amount
                        Text(
                          'Total: \$${itemInfo["totalAmount"].toString()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 80, 2, 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
