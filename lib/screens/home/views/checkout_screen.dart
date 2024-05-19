import 'package:flutter/material.dart';
import 'package:menu_app/components/my_button.dart';
import 'package:menu_app/components/my_number_selector.dart';
import 'package:menu_app/components/my_payment_checkbox.dart';
import 'package:menu_app/components/my_receip.dart';
import 'package:menu_app/components/my_select_date.dart';
import 'package:menu_app/components/my_select_hour.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MySelectDate(),
                  MySelectHour(),
                  MyNumberInput(),
                  MyPaymentCheckbox(),
                  MyReceipt(),
                  const SizedBox(
                    height: 25,
                  ),
                  MyButton(onTap: () {}, text: "Confirm"),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
