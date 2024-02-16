import 'package:flutter/material.dart';
import 'package:gdsc/palette.dart';
import 'package:gdsc/screens/Maps/maps.dart';
import 'package:gdsc/screens/Profile/profilemain.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'package:gdsc/screens/home/post_scroll_page.dart';
import 'package:gdsc/screens/home/title_page.dart';
import 'package:gdsc/screens/home/yo.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int current_index = 0;
  final List<Widget> pages = [
    PostScrollPage(),
    yo(),
    volunteer(),
    Profilemain()
  ];

  void OnTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(2, 78, 166, 1),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome, @username!',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(255, 253, 251, 1),
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              )),
          Text('Location >',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(255, 253, 251, 1),
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              )),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, Maps());
            },
            icon: Icon(Icons.mail),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
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
