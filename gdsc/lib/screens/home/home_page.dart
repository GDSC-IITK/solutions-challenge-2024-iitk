import 'package:flutter/material.dart';
import 'package:gdsc/palette.dart';
import 'package:gdsc/screens/home/post_scroll_page.dart';
import 'package:gdsc/screens/home/title_page.dart';
import 'package:gdsc/screens/home/yo.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int current_index = 0;
  final List<Widget> pages = [PostScrollPage(), yo(), yoo()];

  void OnTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onPressed: () {},
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
      body: pages[current_index],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromRGBO(2, 78, 166, 1),
          iconSize: 26,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          currentIndex: current_index,
          selectedFontSize: 20,
          unselectedFontSize: 14,
          onTap: OnTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }
}
