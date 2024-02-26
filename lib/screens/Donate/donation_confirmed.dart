import 'package:flutter/material.dart';
import 'package:gdsc/screens/Donate/donation_confirmed.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationConfirmPage extends StatelessWidget {
  const DonationConfirmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            "assets/images/donation_confirmed.png",
            width: double.infinity,
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "YOUR DONATION IS CONFIRMED!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Color.fromRGBO(0, 0, 0, 0.769),
                fontWeight: FontWeight.w700,
                fontSize: 22.0,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
                "Thank you for donating, our volunteer will reach you out in a while.",
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(102, 102, 102, 0.77),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                )),
          ),
          InkWell(
            onTap: () {
              nextScreenReplace(context, volunteer());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text("Reach out for volunteer",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                      color: Color.fromRGBO(102, 102, 102, 0.77),
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    )),
              ),
            ),
          )
        ])));
  }
}
