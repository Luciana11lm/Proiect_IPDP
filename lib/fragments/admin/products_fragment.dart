import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:menu_app/api_connection/api_connection.dart';
import 'package:menu_app/fragments/admin/admin_upload_items.dart';
import 'package:menu_app/repositories/models/product.dart';
import 'package:menu_app/repositories/restaurantPreferences/current_restaurant.dart';

class ProductsFragmentScreen extends StatefulWidget {
  const ProductsFragmentScreen({super.key});

  @override
  State<ProductsFragmentScreen> createState() => _ProductsFragmentScreenState();
}

class _ProductsFragmentScreenState extends State<ProductsFragmentScreen> {
  final CurrentRestaurant _currentRestaurant = Get.put(CurrentRestaurant());
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var ingredientsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";

  // functie pentru a lua produsele restaurantului curent din baza de date si a le afisa
  Future<List<Product>> getRestaurantProducts(String idRestaurant) async {
    List<Product> restaurantProductsList = [];

    try {
      var res = await http.post(
        Uri.parse(API.getRestaurantProductsList),
        body: {'idRestaurant': idRestaurant},
      );
      if (res.statusCode == 200) {
        print("Response: ${res.body}");
        var responseBodyOfProducts = jsonDecode(res.body);
        if (responseBodyOfProducts["success"]) {
          (responseBodyOfProducts["itemsData"] as List).forEach((eachRecord) {
            restaurantProductsList.add(Product.fromJson(eachRecord));
          });
        } else {
          Fluttertoast.showToast(msg: "No products found.");
        }
      } else {
        Fluttertoast.showToast(msg: "Error status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return restaurantProductsList;
  }

  //default screen methods
  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() => pickedImageXFile);
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() => pickedImageXFile);
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Item Image",
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                captureImageWithPhoneCamera();
              },
              child: const Text("Capture image with camera",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ),
            SimpleDialogOption(
              onPressed: () {
                pickImageFromPhoneGallery();
              },
              child: const Text("Add the picture of the product",
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ),
            SimpleDialogOption(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  )),
            ),
          ],
        );
      },
    );
  }

  //upload item iamge
  uploadItemImage() async {
    //trimitem un request ca sa adaugam imaginea
    var requestImgurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image"),
    );
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "CLIENT-ID " + "de1dad73551e94c";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);

    var responseFromImgurApi = await requestImgurApi.send();
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = utf8.decode(responseDataFromImgurApi);
    print("Result :: ");
    print(
        resultFromImgurApi); //primim datele in format json si vrem doar link-ul imaginii
    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);

    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    saveItemInfoToDatabase();
  }

  saveItemInfoToDatabase() async {
    //despartitor pentru tag-uri si ingrediente
    List<String> tagsList = tagsController.text.split(',');
    List<String> ingredientsList = ingredientsController.text.split(',');
    var priceProduct = double.tryParse(priceController.text.trim());
    try {
      var response = await http.post(
        Uri.parse(API.uploadNewItem),
        body: {
          'name': nameController.text.toString(),
          'price': priceProduct.toString(),
          'ingredients': ingredientsList.toString(),
          'description': descriptionController.text.toString(),
          'imageUrl': imageLink.toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'idRestaurant': _currentRestaurant.restaurant.idRestaurant.toString(),
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);
        if (resBodyOfUploadItem['success']) {
          Fluttertoast.showToast(msg: "New product added successfully!");
          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            ingredientsController.clear();
            descriptionController.clear();
          });
          Get.to(() => AdminUploadItems());
        } else {
          Fluttertoast.showToast(msg: "Product not uploaded.\n Try again!");
        }
      }
    } catch (errorMsg) {
      print("Error ::" + errorMsg.toString());
    }
  }

  Widget uploadItemFromScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              nameController.clear();
              ratingController.clear();
              tagsController.clear();
              priceController.clear();
              ingredientsController.clear();
              descriptionController.clear();
            });
            Get.to(() => defaultScreen(context));
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => defaultScreen(context));
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            margin: const EdgeInsets.all(16.0), // Add margin for spacing
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(20), // Border radius for image
              image: DecorationImage(
                image: FileImage(
                  File(
                    pickedImageXFile!.path,
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Upload item form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(
                    0.9), // More opaque background for better readability
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // Name
                          TextFormField(
                            controller: nameController,
                            validator: (val) =>
                                val == "" ? "Add product's name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "Product's name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Product ratings
                          TextFormField(
                            controller: ratingController,
                            validator: (val) =>
                                val == "" ? "Add product's ratings" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.rate_review,
                                color: Colors.black,
                              ),
                              hintText: "Product's rating",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Product's tags
                          TextFormField(
                            controller: tagsController,
                            validator: (val) =>
                                val == "" ? "Add product's tags" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "Product's tags",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Product's ingredients
                          TextFormField(
                            controller: ingredientsController,
                            validator: (val) =>
                                val == "" ? "Add product's ingredients" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.food_bank_sharp,
                                color: Colors.black,
                              ),
                              hintText: "Product's ingredients",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Product's description
                          TextFormField(
                            controller: descriptionController,
                            validator: (val) =>
                                val == "" ? "Add product's description" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "Product's description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Product's price
                          TextFormField(
                            controller: priceController,
                            validator: (val) =>
                                val == "" ? "Add product's price" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change_outlined,
                                color: Colors.black,
                              ),
                              hintText: "Product's price",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Button
                          Material(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  Fluttertoast.showToast(
                                      msg: "Uploading now...");
                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Add now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget defaultScreen(context) {
    return FutureBuilder<List<Product>>(
      future: getRestaurantProducts(
          _currentRestaurant.restaurant.idRestaurant.toString()),
      builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnapShot.hasError) {
          return const Center(child: Text("An error occurred"));
        }
        if (dataSnapShot.data == null) {
          return const Center(child: Text("No items found"));
        }
        if (dataSnapShot.data!.isNotEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: dataSnapShot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Product eachProductData = dataSnapShot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                            height: 50,
                            width: 50,
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
                        title: Text(
                          eachProductData.name.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          eachProductData.description.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Text(
                          eachProductData.price.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialogBoxForImagePickingAndCapturing();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.plus),
                        SizedBox(width: 10),
                        Text(
                          'Add a New Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null
        ? defaultScreen(context)
        : uploadItemFromScreen();
  }
}
