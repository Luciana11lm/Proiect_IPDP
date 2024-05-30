import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/user/item/item_details_screen.dart';
import 'package:menu_app/repositories/models/product.dart';
import 'package:http/http.dart' as http;

class SearchItems extends StatefulWidget {
  const SearchItems({this.typedKeyWords});

  final String? typedKeyWords;
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  Future<List<Product>> readSearchRecordFound() async {
    List<Product> productSearchList = [];
    if (searchController.text != null) {
      try {
        var res = await http.post(
          Uri.parse(API.searchItems),
          body: {
            "typedKeyWords": searchController.text,
          },
        );
        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);
          if (responseBodyOfSearchItems["success"]) {
            (responseBodyOfSearchItems["itemsFoundData"] as List).forEach(
              (eachItemData) {
                productSearchList.add(
                  Product.fromJson(eachItemData),
                );
              },
            );
          }
        } else {
          Fluttertoast.showToast(msg: "Error status code is not 200");
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }
    }
    return productSearchList;
  }

  @override
  void initState() {
    super.initState();
    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

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

  Widget searchItemDesignWidget(context) {
    return FutureBuilder(
      future: readSearchRecordFound(),
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
