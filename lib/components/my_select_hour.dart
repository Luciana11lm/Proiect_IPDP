import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class MySelectHour extends StatelessWidget {
  const MySelectHour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now(); // Initialize selectedTime

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 10),
          child: TextField(
            controller: _timeController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              labelText: 'TIME',
              filled: true,
              prefixIcon: Icon(Icons.access_time),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
            readOnly: true,
            onTap: () async {
              await _selectTime(context);
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        final now = DateTime.now();
        final selectedDateTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);
        final formattedTime =
            DateFormat.jm().format(selectedDateTime); // Format the time
        _timeController.text = formattedTime;
      });
    }
  }
}
