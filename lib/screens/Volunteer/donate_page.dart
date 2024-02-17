import 'package:flutter/material.dart';
import 'package:gdsc/palette.dart';
import 'package:gdsc/screens/home/post_scroll_page.dart';
import 'package:gdsc/screens/home/title_page.dart';

import 'package:google_fonts/google_fonts.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            child: Center(
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Donate",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0,
                              ))),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Your step towards eradicating hunger",
                              style: GoogleFonts.inter(
                                color: Color.fromRGBO(102, 102, 102, 0.71),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ))),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(25),
                          child: Image.asset(
                              'assets/images/donate_page_picture.png')),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Organisation",
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
                      Container(
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
                              ])),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                      const SizedBox(
                        height: 10,
                      ),
                    ])))));
  }
}
