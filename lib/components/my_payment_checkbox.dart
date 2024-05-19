import 'package:flutter/material.dart';

class MyPaymentCheckbox extends StatelessWidget {
  const MyPaymentCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyPaymentCheckbox();
}

class _MyPaymentCheckbox extends State<Home> {
  String selected = "";
  List checkListItems = [
    {
      "id": 0,
      "value": true,
      "title": "Cash",
    },
    {
      "id": 1,
      "value": false,
      "title": "Card",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            // Add your text here
            const Text(
              "Please select a payment method:  ",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
            // Add some spacing between the text and the checkboxes
            Column(
              children: List.generate(
                checkListItems.length,
                (index) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    checkListItems[index]["title"],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  value: checkListItems[index]["value"],
                  activeColor: Colors.orange, // Set the active color to orange

                  onChanged: (value) {
                    setState(() {
                      for (var element in checkListItems) {
                        element["value"] = false;
                      }
                      checkListItems[index]["value"] = true;
                      selected = checkListItems[index]["title"];
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
