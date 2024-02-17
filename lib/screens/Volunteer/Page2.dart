import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'package:gdsc/screens/home/home_page.dart';
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
          backgroundColor: Color.fromRGBO(2, 78, 166, 1),
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
            "assets/images/Volunteer.png",
            width: double.infinity,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Details",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Item's name: $itemname",
              style: TextStyle(fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Quantity: $quantity",
              style: TextStyle(fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Organization: $organization",
              style: TextStyle(fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Location: $location",
              style: TextStyle(fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Remarks: $remarks",
              style: TextStyle(fontFamily: "Inter"),
            ),
          ),
          InkWell(
            onTap: () {
              nextScreenReplace(context, HomePage());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(2, 78, 166, 1),
                ),
                width: double.infinity,
                height: 50,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Confirm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontSize: 25, fontFamily: "Inter"),
                  ),
                ),
              ),
            ),
          )
        ])));
  }
}
