import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class ProductsFragmentScreen extends StatefulWidget {
  const ProductsFragmentScreen({super.key});

  @override
  State<ProductsFragmentScreen> createState() => _ProductsFragmentScreenState();
}

class _ProductsFragmentScreenState extends State<ProductsFragmentScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

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

  Widget uploadItemFromScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FileImage(
                File(
                  pickedImageXFile!.path,
                ),
              ),
              fit: BoxFit.cover,
            )),
          ),
        ],
      ),
    );
  }

  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 80), // Leave space for the button
            itemCount: 10, // Simulated number of products
            itemBuilder: (context, index) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      'https://via.placeholder.com/50', // Placeholder image URL
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    'Product Name $index',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Product description goes here.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Text(
                    '\$${(index + 1) * 5}.99',
                    style: TextStyle(
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
                // Add your logic for adding a new product here
                showDialogBoxForImagePickingAndCapturing();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15),
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
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFromScreen();
  }
}
