import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNumberInput extends StatelessWidget {
  const MyNumberInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController numberController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
      child: TextField(
        controller: numberController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          fillColor: Colors.white,
          labelText: 'Numbers of people',
          filled: true,
          prefixIcon: Icon(Icons.person_outline),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        onChanged: (value) {
          if (int.tryParse(value) != null) {
            int number = int.parse(value);
            if (number > 12) {
              // If number exceeds 12, set it to 12
              numberController.text = '12';
            }
          }
        },
      ),
    );
  }
}
