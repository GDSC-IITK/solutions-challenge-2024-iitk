import 'dart:math';
// import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/location.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    // getCurrentLocation(context).then((value) async {
    //   print("My Current Location");
    // });
    loadData();
  }

  Map<String, dynamic> _allData = {};

  loadData() async {
    print("Loading Data");
    String baseUrl = await fetchUrlAndGetData();
    print(baseUrl);
    GeoPoint? currentLocation = await getCurrentLocation(context);
    // getCurrentLocation(context).then((value) async {
    //   print("My Current Location");
    // });

    // setState(() {});
    // Check if the location was successfully retrieved
    if (currentLocation != null) {
      // Append the coordinates to the URL
      String fullUrl =
          "$baseUrl/kiosks?lat=${currentLocation.latitude}&lon=${currentLocation.longitude}";
      print(fullUrl);
      // Make the HTTP GET request
      var response = await http.get(Uri.parse(fullUrl));

      // Check for a successful response and parse the JSON
      if (response.statusCode == 200) {
        // Parse the JSON response into a list of coordinate pairs
        List<dynamic> jsonData = json.decode(response.body);
        List<GeoPoint> coordinatePairs = jsonData.map((item) {
          return GeoPoint(item[0], item[1]); // Create a GeoPoint for each pair
        }).toList();
        // Update the _allData with the new data
        setState(() {
          _allData = {
            'location': coordinatePairs,
          };
        });
      } else {
        print("Failed to load data from API");
      }
    } else {
      print("Failed to get current location");
    }
    Map<String, dynamic> data = await fetchAllDocumentsFromCollection();
    setState(() {
      _allData = data;
      print(data);
    });
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

  Future<String> fetchUrlAndGetData() async {
    // Step 1: Fetch the document from Firestore
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('Resources')
        .doc('Lgabj22b2b3EkKyTe3T7')
        .get();

    // Step 2: Extract the URL from the document
    String baseUrl = document['modelURL'];
    print(baseUrl);
    return baseUrl;
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
