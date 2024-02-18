import 'package:flutter/material.dart';
import 'package:gdsc/screens/Donate/donation_confirmed.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Donate_3 extends StatelessWidget {
  const Donate_3(
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
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            "assets/images/donation_confirm.png",
            width: double.infinity,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              "Details",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Item's name: $itemname",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Quantity: $quantity",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Organization: $organization",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Location: $location",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Remarks: $remarks",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          InkWell(
            onTap: () {
              nextScreenReplace(context, DonationConfirmPage());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(2, 78, 166, 1),
                  ),
                  width: Width / 1.1,
                  height: 50,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Confirm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "Inter"),
                    ),
                  ),
                ),
              ),
            ),
          )
        ])));
  }
}
