import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MySelectDate extends StatelessWidget {
  const MySelectDate({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 30),
          child: TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              labelText: 'DATE',
              filled: true,
              prefixIcon: Icon(Icons.calendar_today),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
            readOnly: true,
            onTap: () async {
              await _selectDate();
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
