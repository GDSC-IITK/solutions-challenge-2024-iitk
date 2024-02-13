import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/DistancePage/custom.dart';
import 'package:gdsc/screens/Volunteer/DistancePage/twotofive.dart';
import 'package:gdsc/screens/Volunteer/Vcard.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class volunteer extends StatefulWidget {
  const volunteer({super.key});

  @override
  State<volunteer> createState() => _volunteerState();
}

class _volunteerState extends State<volunteer> {
  bool b1 = true;
  bool b2 = false;

  bool b3 = false;

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width; // Gives the width
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Page"),
        backgroundColor: Color.fromRGBO(78, 134, 199, 0.83),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        b1 = true;
                        b2 = false;
                        b3 = false;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: Width / 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.fromRGBO(2, 78, 166, 1),
                          ),
                          color: b1 == true
                              ? Color.fromRGBO(2, 78, 166, 1)
                              : Colors.white),
                      child: Center(
                        child: Text(
                          "0-2 km",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: b1 == true
                                ? Colors.white
                                : Color.fromRGBO(2, 78, 166, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: () {
                      nextScreenReplace(context, twotofive());
                      setState(() {
                        b1 = false;
                        b2 = true;
                        b3 = false;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: Width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color.fromRGBO(2, 78, 166, 1),
                        ),
                        color: b2 == false
                            ? Colors.white
                            : Color.fromRGBO(2, 78, 166, 1),
                      ),
                      child: Center(
                        child: Text(
                          "2-5 km",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: b2 == false
                                ? Color.fromRGBO(2, 78, 166, 1)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: () {
                      nextScreenReplace(context, custom());
                      setState(() {
                        b1 = false;
                        b2 = false;
                        b3 = true;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: Width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color.fromRGBO(2, 78, 166, 1),
                        ),
                        color: b3 == false
                            ? Colors.white
                            : Color.fromRGBO(2, 78, 166, 1),
                      ),
                      child: Center(
                        child: Text(
                          "Custom",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: b3 == false
                                ? Color.fromRGBO(2, 78, 166, 1)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Vcard(item: "item", quantity: "quantity", location: "location"),
        ],
      ),
    );
  }
}
