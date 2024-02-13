import 'package:flutter/material.dart';
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
                          nextScreen(context, const SignUpPage());
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Already have an account ? Login",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(255, 253, 251, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          )),
                    ]))),
              ),
            ])))));
  }
}


// class _LoginPageState extends State<LoginPage> {
//   final formKey = GlobalKey<FormState>();
//   String email = "";
//   String password = "";
//   bool _isLoading = false;
//   AuthService authService = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                     "assets/images/black-marble-texture-background.jpg"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Center(
//                 child: Form(
//                     key: formKey,
//                     child: Column(children: [
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Image.asset('assets/images/logo.png'),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           style: const TextStyle(
//                             fontFamily: 'BrunoAce',
//                             fontSize: 20,
//                           ),
//                           children: <TextSpan>[
//                             TextSpan(
//                                 text: 'DESIGN. ',
//                                 style: TextStyle(color: Colors.white)),
//                             TextSpan(
//                                 text: 'BUILD. ',
//                                 style: TextStyle(color: Colors.red)),
//                             TextSpan(
//                                 text: 'RACE.',
//                                 style: new TextStyle(color: Colors.white)),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               border: Border.all(color: Colors.white),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20))),
//                           padding: EdgeInsets.all(30),
//                           child: Column(children: [
//                             Text('WELCOME',
//                                 style: GoogleFonts.firaMono(
//                                     color: Colors.white,
//                                     fontSize: 40.0,
//                                     fontWeight: FontWeight.bold)),
//                             Text('Login to your account',
//                                 style: GoogleFonts.firaMono(
//                                     color: Colors.white,
//                                     fontSize: 20.0,
//                                     fontWeight: FontWeight.bold)),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             ConstrainedBox(
//                                 constraints:
//                                     const BoxConstraints(maxWidth: 400),
//                                 child: TextFormField(
//                                   decoration: textInputDecoration.copyWith(
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       enabledBorder: const OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       errorBorder: const OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       labelText: "Email",
//                                       labelStyle: GoogleFonts.firaMono(
//                                         color: Colors.white,
//                                         fontSize: 15.0,
//                                       ),
//                                       errorStyle: GoogleFonts.firaMono(
//                                         color: Colors.white,
//                                         fontSize: 10.0,
//                                       ),
//                                       prefixIcon: const Icon(
//                                         Icons.email,
//                                         color: Colors.white,
//                                       )),
//                                   onChanged: (val) {
//                                     setState(() {
//                                       email = val;
//                                     });
//                                   },

//                                   // check tha validation
//                                   validator: (val) {
//                                     return RegExp(
//                                                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                             .hasMatch(val!)
//                                         ? null
//                                         : "Please enter a valid email";
//                                   },
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             ConstrainedBox(
//                                 constraints:
//                                     const BoxConstraints(maxWidth: 400),
//                                 child: TextFormField(
//                                   obscureText: true,
//                                   decoration: textInputDecoration.copyWith(
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       enabledBorder: const OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       errorBorder: const OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       focusedErrorBorder: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         borderSide: const BorderSide(
//                                           color: Colors.white,
//                                           width: 2.0,
//                                         ),
//                                       ),
//                                       labelText: "Password",
//                                       labelStyle: GoogleFonts.firaMono(
//                                         color: Colors.white,
//                                         fontSize: 15.0,
//                                       ),
//                                       errorStyle: GoogleFonts.firaMono(
//                                         color: Colors.white,
//                                         fontSize: 10.0,
//                                       ),
//                                       prefixIcon: Icon(Icons.lock,
//                                           color: Colors.white)),
//                                   validator: (val) {
//                                     if (val!.length < 6) {
//                                       return "Password must be at least 6 characters";
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   onChanged: (val) {
//                                     setState(() {
//                                       password = val;
//                                     });
//                                   },
//                                 )),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             ConstrainedBox(
//                                 constraints:
//                                     const BoxConstraints(maxWidth: 400),
//                                 child: Center(
//                                     child: Row(
//                                   children: [
//                                     Container(
//                                       decoration: const BoxDecoration(
//                                         // gradient: const LinearGradient(
//                                         //   colors: [
//                                         //     Pallete.gradient1,
//                                         //     Pallete.gradient2,
//                                         //     Pallete.gradient3,
//                                         //   ],
//                                         //   begin: Alignment.bottomLeft,
//                                         //   end: Alignment.topRight,
//                                         // ),
//                                         color: Colors.white,
//                                       ),
//                                       child: ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.transparent,
//                                           shadowColor: Colors.transparent,
//                                           fixedSize: const Size(190, 55),
//                                         ),
//                                         child: Text(
//                                           "LOG IN",
//                                           style: GoogleFonts.robotoMono(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15.0,
//                                           ),
//                                         ),
//                                         onPressed: () {
//                                           login();
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                     Container(
//                                       decoration: const BoxDecoration(
//                                         // gradient: const LinearGradient(
//                                         //   colors: [
//                                         //     Pallete.gradient1,
//                                         //     Pallete.gradient2,
//                                         //     Pallete.gradient3,
//                                         //   ],
//                                         //   begin: Alignment.bottomLeft,
//                                         //   end: Alignment.topRight,
//                                         // ),
//                                         color: Colors.white,
//                                       ),
//                                       child: ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.transparent,
//                                           shadowColor: Colors.transparent,
//                                           fixedSize: const Size(190, 55),
//                                         ),
//                                         child: Text(
//                                           "REGISTER",
//                                           style: GoogleFonts.robotoMono(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 15.0,
//                                           ),
//                                         ),
//                                         onPressed: () {
//                                           nextScreen(
//                                               context, const RegisterPage());
//                                         },
//                                       ),
//                                     )
//                                   ],
//                                 ))),
//                           ])),
//                       const SizedBox(
//                         height: 400,
//                       ),
//                     ])),
//               ),
//             )));
//   }

//   login() async {
//     if (formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//       await authService
//           .loginWithUserNameandPassword(email, password)
//           .then((value) async {
//         if (value == true) {
//           QuerySnapshot snapshot =
//               await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
//                   .gettingUserData(email);
//           // saving the values to our shared preferences
//           await HelperFunctions.saveUserLoggedInStatus(true);
//           await HelperFunctions.saveUserEmailSF(email);
//           await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
//           await HelperFunctions.saveUserSubSystemSF(snapshot.docs[0]['sub']);
//           await HelperFunctions.saveUserLevelSF(snapshot.docs[0]['level']);
//           nextScreenReplace(context, const HomePage());
//         } else {
//           showSnackbar(context, Colors.red, value);
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       });
//     }
//   }
// }
