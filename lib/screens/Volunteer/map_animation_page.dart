import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/location.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MapAnimationPage extends StatefulWidget {
  const MapAnimationPage(
      {super.key, required this.donationId, required this.pickupId});

  final String donationId;
  final String pickupId;
  @override
  State<MapAnimationPage> createState() => _MapAnimationPageState();
}

class _MapAnimationPageState extends State<MapAnimationPage> {
  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    loadData();
  }

  Map<String, dynamic> _allData = {};

  loadData() async {
    print("Loading Data");
    Map<String, dynamic> data = await fetchAllDocumentsFromCollection();
    setState(() {
      _allData = data;
      print(data);
    });
    getCurrentLocation(context).then((value) async {
      print("My Current Location");
    });
    setState(() {});
  }

  Future<Map<String, dynamic>> fetchAllDocumentsFromCollection() async {
    try {
      // Get reference to the collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection('DatabaseLocations');

      // Get all documents from the collection
      QuerySnapshot querySnapshot = await collection.get();

      // Create an empty map to store document data
      Map<String, dynamic> documentsMap = {};

      // Loop through each document and add it to the map
      querySnapshot.docs.forEach((doc) {
        documentsMap[doc.id] = doc.data();
      });

      // Return the map of document data
      return documentsMap;
    } catch (error) {
      // Handle any errors that might occur
      print('Error fetching documents: $error');
      return {}; // Return an empty map in case of error
    }
  }

  int generateRandomNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(4) +
        3; // Generates a random number between 0 and 3, then adds 3 to get a number between 3 and 6
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: generateRandomNumber()), () {
      nextScreenReplace(
          context,
          Location(
            all: _allData,
            donationId: widget.donationId,
            pickupId: widget.pickupId,
          ));
    });
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
