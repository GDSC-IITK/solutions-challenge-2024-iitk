import 'package:flutter/material.dart';

class yo extends StatefulWidget {
  const yo({super.key});

  @override
  State<yo> createState() => _yoState();
}

class _yoState extends State<yo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      const SizedBox(
        height: 300,
      ),
      Text(
        "Higkhhkjhghjggioiuhgjhlkhlsa hfloahfounacdioufagirtbweicytriouewyarobuasoridjahsflkahsdfrhewquocrbownsljd1",
        style: TextStyle(color: Colors.black),
      ),
    ]));
  }
}
