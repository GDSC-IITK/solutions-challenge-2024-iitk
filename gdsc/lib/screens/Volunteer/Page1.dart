import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/Page2.dart';
import 'package:gdsc/screens/home/post_scroll_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Page1 extends StatelessWidget {
  const Page1(
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            "assets/images/img.png",
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              itemname,
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
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
          InkWell(
            onTap: () {
              nextScreen(
                context,
                Page2(
                    itemname: itemname,
                    quantity: quantity,
                    location: location,
                    remarks: remarks,
                    organization: organization),
              );
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
                    "Volunteer",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
