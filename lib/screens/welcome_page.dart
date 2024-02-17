import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
            ),
            child: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
              const SizedBox(
                height: 250,
              ),
              Image.asset(
                'assets/images/home.jpeg',
                fit: BoxFit.contain,
                width: 344,
              ),
              Text("Do you want to donate food?",
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(2, 78, 166, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 23.0,
                  )),
              const SizedBox(
                height: 30,
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                      "Empower change with every meal. Sign up to connect restaurants, turning surplus into support",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(2, 78, 166, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0,
                      ))),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 270.0,
                color: Colors.transparent,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 121, 184, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        )),
                    child: Center(
                        child: Column(children: [
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          fixedSize: const Size(190, 55),
                        ),
                        child: Text(
                          "Get Started",
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(2, 78, 166, 1),
                            fontWeight: FontWeight.w600,
                            fontSize: 23.0,
                          ),
                        ),
                        onPressed: () {
                          nextScreenReplace(context, const SignUpPage());
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          nextScreenReplace(context, const LoginPage());
                        },
                        child: Text("Already have an account ? Login",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Color.fromRGBO(255, 253, 251, 1),
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                            )),
                      ),
                    ]))),
              ),
            ])))));
  }
  
}
