import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/screens/welcome_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class VisionPage extends StatefulWidget {
  const VisionPage({super.key});

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
   @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
    setState(() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false);
    });
  });
    }
  }
  
  final List<ImageWithText> imagesWithText = [
    ImageWithText(
      'Join us in ending hunger. Your support as a donor or volunteer can be a beacon of hope for those in need.',
      'assets/images/vision_1.png',
    ),
    ImageWithText(
      'Donate your excess food by posting its status. Generous donors trigger notifications for nearby volunteers.',
      'assets/images/vision_2.png',
    ),
    ImageWithText(
      'Deliver the excess food its destination. Volunteers act as vectors for delivering food.',
      'assets/images/vision_3.png',
    ),
  ];

  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          Container(
              padding: EdgeInsets.all(20),
              width: 295,
              height: 365,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: PageView.builder(
                    onPageChanged: (index) =>
                        setState(() => _currentImageIndex = index),
                    itemCount: imagesWithText.length,
                    itemBuilder: (context, index) {
                      ImageWithText imageWithText = imagesWithText[index];
                      return Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 300),
                            child: Image.asset(
                              imageWithText.imageUrl,
                              fit: BoxFit.contain,
                              height: 117,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(imagesWithText.length, (index) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                );
                              })),
                          const SizedBox(
                            height: 20,
                          ),
                          Text("VISION",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Color.fromRGBO(18, 89, 172, 1),
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(imageWithText.text,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Color.fromRGBO(18, 89, 172, 0.41),
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              )),
                        ],
                      );
                    },
                  ))),
          const SizedBox(
            height: 100,
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
                      "Next",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(2, 78, 166, 1),
                        fontWeight: FontWeight.w600,
                        fontSize: 23.0,
                      ),
                    ),
                    onPressed: () {
                      nextScreenReplace(context, const WelcomePage());
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
        ],
      ),
    ));
  }
}

class ImageWithText {
  final String text;
  final String imageUrl;

  ImageWithText(this.text, this.imageUrl);
}
