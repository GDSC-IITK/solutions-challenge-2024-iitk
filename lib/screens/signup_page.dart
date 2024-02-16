//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:gdsc/palette.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/services/auth_services.dart';
import 'package:gdsc/widgets/SnackBar.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  String userName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
            ),
            child: Center(
                child: Column(children: [
              const SizedBox(
                height: 250,
              ),
              Expanded(
                  child: Container(
                color: Colors.transparent,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(67, 121, 184, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          topRight: Radius.circular(60.0),
                        )),
                    child: Center(
                        child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    padding: EdgeInsets.only(
                                        left: 45, top: 40, right: 40),
                                    child: Form(
                                        key: formKey,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Create an account",
                                                  style: GoogleFonts.poppins(
                                                    color: Color.fromRGBO(
                                                        255, 253, 251, 1),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 25.0,
                                                  )),
                                              Text("Sign up to continue",
                                                  style: GoogleFonts.poppins(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.59),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.0,
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(),
                                                  child: TextFormField(
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Full Name",
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                            ),
                                                            errorStyle:
                                                                GoogleFonts
                                                                    .firaMono(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                            ),
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        fullName = val;
                                                      });
                                                    },
                                                    validator: (val) {
                                                      if (val!.isNotEmpty) {
                                                        return null;
                                                      } else {
                                                        return "Name cannot be empty";
                                                      }
                                                    },
                                                  )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(),
                                                  child: TextFormField(
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Username",
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                            ),
                                                            errorStyle:
                                                                GoogleFonts
                                                                    .firaMono(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13.0,
                                                            ),
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        userName = val;
                                                      });
                                                    },
                                                    validator: (val) {
                                                      if (val!.isNotEmpty) {
                                                        return null;
                                                      } else {
                                                        return "Name cannot be empty";
                                                      }
                                                    },
                                                  )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(),
                                                  child: TextFormField(
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            labelText: "Email",
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                            ),
                                                            errorStyle:
                                                                GoogleFonts
                                                                    .firaMono(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                            ),
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.email,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        email = val;
                                                      });
                                                    },

                                                    // check tha validation
                                                    validator: (val) {
                                                      return RegExp(
                                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                              .hasMatch(val!)
                                                          ? null
                                                          : "Please enter a valid email";
                                                    },
                                                  )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(),
                                                  child: TextFormField(
                                                    obscureText: true,
                                                    decoration: textInputDecoration
                                                        .copyWith(
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            errorBorder:
                                                                const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            focusedErrorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            labelText:
                                                                "Password",
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                            ),
                                                            errorStyle:
                                                                GoogleFonts
                                                                    .firaMono(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                            ),
                                                            prefixIcon:
                                                                const Icon(
                                                              Icons.lock,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                    validator: (val) {
                                                      if (val!.length < 6) {
                                                        return "Password must be at least 6 characters";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    onChanged: (val) {
                                                      setState(() {
                                                        password = val;
                                                      });
                                                    },
                                                  )),
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              Center(
                                                  child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  fixedSize:
                                                      const Size(190, 55),
                                                ),
                                                child: Text(
                                                  "Get Started",
                                                  style: GoogleFonts.poppins(
                                                    color: Color.fromRGBO(
                                                        2, 78, 166, 1),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 23.0,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  register();
                                                },
                                              )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                  child: Text(
                                                      "Already have an account ? Login",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Color.fromRGBO(
                                                            255, 253, 251, 1),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15.0,
                                                      ))),
                                            ])))),
                          ]),
                    ))),
              )),
            ]))));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password, userName)
          .then((value) async {
        if (value == true) {
          nextScreenReplace(context, const LoginPage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
