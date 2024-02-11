import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/Vcard.dart';

class volunteer extends StatefulWidget {
  const volunteer({super.key});

  @override
  State<volunteer> createState() => _volunteerState();
}

class _volunteerState extends State<volunteer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Page"),
        backgroundColor: Color.fromRGBO(78, 134, 199, 0.83),
      ),
      body: const SingleChildScrollView(
        child: Material(
          child: Column(
            children: [
              Vcard(item: "item", quantity: "quantity", location: "location")
            ],
          ),
        ),
      ),
    );
  }
}
