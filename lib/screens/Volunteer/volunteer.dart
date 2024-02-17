import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/DistancePage/custom.dart';
import 'package:gdsc/screens/Volunteer/DistancePage/twotofive.dart';
import 'package:gdsc/screens/Volunteer/Vcard.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:http/http.dart' as http;

class volunteer extends StatefulWidget {
  const volunteer({super.key});

  @override
  State<volunteer> createState() => _volunteerState();
}

class _volunteerState extends State<volunteer>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _newIndex = 0;

  @override
  void initState() {
    super.initState();

    fetchData();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Map<String, dynamic> distance = {'distance': 'Loading...'};

  Future<void> fetchData() async {
    var url =
        "https://api.jsonbin.io/v3/qs/65cc9a5d1f5677401f2f1a3c"; // Replace with your JSON bin ID
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        distance = jsonDecode(response.body) as Map<String, dynamic>;
      });
    } else {
      print("Unable to fetch data. Status code: ${response.statusCode}");
    }
  }

  Widget _tab(int index) {
    double Width = MediaQuery.of(context).size.width; // Gives the width

    List<Widget> VCard = [
      const Vcard(item: "item", quantity: "quantity", location: "location"),
      const Vcard(item: "item", quantity: "quantity1", location: "location"),
      const Vcard(item: "item", quantity: "quantity2", location: "location"),
    ];

    return SingleChildScrollView(
      child: VCard[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(78, 134, 199, 0.83),
            ),
            height: 50,
            child: const Center(
              child: Text(
                "Volunteer Page",
                style: TextStyle(),
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromRGBO(2, 78, 166, 1),
                ),
                color: _tabController!.index == 0
                    ? Color.fromRGBO(2, 78, 166, 1)
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  "0-2 km",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _tabController!.index == 0
                        ? Colors.white
                        : Color.fromRGBO(2, 78, 166, 1),
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromRGBO(2, 78, 166, 1),
                ),
                color: _tabController!.index == 1
                    ? Color.fromRGBO(2, 78, 166, 1)
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  "2-5 km",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _tabController!.index == 1
                        ? Colors.white
                        : Color.fromRGBO(2, 78, 166, 1),
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromRGBO(2, 78, 166, 1),
                ),
                color: _tabController!.index == 2
                    ? Color.fromRGBO(2, 78, 166, 1)
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  "Custom",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _tabController!.index == 2
                        ? Colors.white
                        : Color.fromRGBO(2, 78, 166, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _tab(0),
          _tab(1),
          _tab(2),
        ],
      ),
    );
  }
}
