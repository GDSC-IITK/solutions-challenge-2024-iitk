import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';

class IndividualDonateContainer extends StatefulWidget {
  const IndividualDonateContainer({Key? key}) : super(key: key);

  @override
  State<IndividualDonateContainer> createState() =>
      _IndividualDonateContainerState();
}

class _IndividualDonateContainerState extends State<IndividualDonateContainer> {
  String _selectedValue = 'Option 1';
  List<String> _options = [
    'in Kilograms(kg)',
    'in Liters(l)',
    'in Pounds(lb)',
    'in Ounces(oz)',
    'in Pieces'
  ];
  @override
  void initState() {
    super.initState();
    _selectedValue = _options.first;
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child:
              Image.asset('assets/images/individual_donate_page_picture.png')),
      const SizedBox(
        height: 10,
      ),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Full Name",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            )),
            const SizedBox(
              height: 10,
            )
          ])),
      Center(
          child: Container(
              child: Row(children: <Widget>[
        Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity",
                          style: GoogleFonts.inter(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const TextField(
                          decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      )),
                      const SizedBox(
                        height: 10,
                      )
                    ]))),
        Container(
            alignment: Alignment.centerLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 25,
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
                  child: DropdownButton<String>(
                      value: _selectedValue,
                      items: _options.map((value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      }),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ]))
      ]))),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Address",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            )),
          ])),
      Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Continue with current location",
            style: GoogleFonts.inter(
              color: Color.fromRGBO(102, 102, 102, 0.7),
              fontWeight: FontWeight.w600,
              fontSize: 13.0,
            ),
          )),
      const SizedBox(
        height: 10,
      ),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Comments",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            const TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            )),
          ])),
    ]));
  }
}
