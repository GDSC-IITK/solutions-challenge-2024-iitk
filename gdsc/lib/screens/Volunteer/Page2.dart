import 'package:flutter/material.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Page2 extends StatelessWidget {
  const Page2(
      {super.key,
      required this.itemname,
      required this.quantity,
      required this.location,
      required this.remarks,
      required this.organization});

  final String itemname;
  final String quantity;
  final String location;
  final String remarks;
  final String organization;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(78, 134, 199, 0.83),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            "assets/images/home.jpeg",
            width: double.infinity,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Details",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Item's name: $itemname"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Quantity: $quantity"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Organization: $organization"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Location: $location"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Remarks: $remarks"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1, color: Colors.brown),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Confirm")),
            ],
          )
        ])));
  }
}
