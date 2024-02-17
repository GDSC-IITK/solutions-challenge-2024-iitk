import 'package:flutter/material.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MapAnimationPage extends StatefulWidget {
  const MapAnimationPage({super.key});

  @override
  State<MapAnimationPage> createState() => _MapAnimationPageState();
}

class _MapAnimationPageState extends State<MapAnimationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: Center(
                child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              Lottie.asset('assets/animations/Animation - 1708083321954.json'),
              const SizedBox(
                height: 100,
              ),
              Center(
                  child: Text(
                "Based on your location, AI is detecting nearby locations",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 23.0,
                ),
              )),
            ],
          ),
        ))));
  }
}
