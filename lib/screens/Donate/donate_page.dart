import 'package:flutter/material.dart';
import 'package:gdsc/screens/Donate/donate_3.dart';
import 'package:gdsc/screens/Donate/individual_donate_page.dart';
import 'package:gdsc/screens/Donate/organization_donate_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final formKey = GlobalKey<FormState>();

  bool _isOn = false;
  String itemname = "null";
  String quantity = "0";
  String location = "null";
  String remarks = "null";
  String organization = "null";

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
            child: Center(
                child: Form(
                    key: formKey,
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isOn
                                  ? Text("Donate as an Organization",
                                      style: GoogleFonts.inter(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 23.0,
                                      ))
                                  : Text("Donate as an Individual",
                                      style: GoogleFonts.inter(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 23.0,
                                      )),
                              Text("Your step towards eradicating hunger",
                                  style: GoogleFonts.inter(
                                    color: Color.fromRGBO(102, 102, 102, 0.77),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ))
                            ],
                          ),
                          Spacer(),
                          CupertinoSwitch(
                            value: _isOn,
                            activeColor: Color.fromRGBO(50, 167, 20, 1),
                            trackColor: _isOn
                                ? Color.fromRGBO(2, 78, 166, 1)
                                : Color.fromRGBO(2, 78, 166, 1),
                            onChanged: (bool? value) {
                              setState(() {
                                _isOn = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                      _isOn
                          ? OrganisationDonateContainer()
                          : IndividualDonateContainer(),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          nextScreenReplace(
                            context,
                            Donate_3(
                                itemname: itemname,
                                quantity: quantity,
                                location: location,
                                remarks: remarks,
                                organization: organization),
                          );
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
                                  "Continue",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Inter"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ])))));
  }
}
