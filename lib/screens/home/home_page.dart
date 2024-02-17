import 'package:flutter/material.dart';
import 'package:gdsc/palette.dart';
import 'package:gdsc/screens/Maps/maps.dart';
import 'package:gdsc/screens/Maps/spotsomeone.dart';
import 'package:gdsc/screens/Profile/profilemain.dart';
import 'package:gdsc/screens/Volunteer/donate_page.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'package:gdsc/screens/home.dart';
import 'package:gdsc/screens/home/post_scroll_page.dart';
import 'package:gdsc/screens/home/title_page.dart';
import 'package:gdsc/screens/home/yo.dart';
import 'package:gdsc/screens/notification_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int current_index = 0;
  final List<Widget> pages = [
    HomePagenew(),
    DonatePage(),
    volunteer(),
    Profilemain()
  ];

  void OnTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  String _userMail = "";
  String _UserName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Function to load user's name from Firebase
  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userMail = user.email ?? "";
      });
      Map<String, String> userData = await fetchData(_userMail);
      setState(() {
        _UserName = userData['userName'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(2, 78, 166, 1),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome, @$_UserName!',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(255, 253, 251, 1),
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              )),
          Text('Your step to eradicate hunger',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(255, 253, 251, 1),
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              )),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Column(
                          children: [
                            Text(
                              "Spot Someone in Need",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Inter"),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Help us reach those in need! If you come across someone who could benefit from our support, you can pin their location on the map.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Inter"),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                nextScreen(context, spotSomeone());
                              },
                              child: Text(
                                "Go Ahead",
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22),
                              ),
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(160, 59)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF024EA6))),
                            )
                          ],
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ));
            },
            icon: Icon(Icons.add),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              nextScreen(context, NotificationScreen());
            },
            icon: Icon(Icons.notifications),
            color: Colors.white,
          ),
        ],
      ),
      body: pages.elementAt(current_index),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(2, 78, 166, 1),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 26,
            backgroundColor: Color.fromRGBO(2, 78, 166, 1),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            currentIndex: current_index,
            selectedFontSize: 20,
            unselectedFontSize: 14,
            onTap: (index) {
              OnTapped(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/Icons/Donation.png")),
                  label: "Donate"),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/Icons/Vactivity.png")),
                  label: "Volunteer"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
      ),
    );
  }
}
