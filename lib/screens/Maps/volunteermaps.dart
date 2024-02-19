import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class volunteerMaps extends StatefulWidget {
  const volunteerMaps({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<volunteerMaps> createState() => _MapsState();
}

class _MapsState extends State<volunteerMaps> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition loc =
      const CameraPosition(target: LatLng(26.511639, 80.230954), zoom: 14);
  Map<String, dynamic>? _donData;
  List<Marker> _marker = [];
  final List<Marker> _list = [
    // const Marker(
    //     markerId: MarkerId("1"),
    //     position: LatLng(26.514323, 80.231223),
    //     infoWindow: InfoWindow(title: "Current position"))
  ];
  String _userName = '';
  GeoPoint _coord = GeoPoint(0, 0);
  String _address = '';
  String _quantity = '';
  String _phoneNo = '';
  String _userId = '';

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    loadData();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>?> fetchDocumentAsJsonByUID(
      String collectionName, String uid) async {
    try {
      // Get the Firestore instance and reference to the collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      // Fetch the document with the given UID
      DocumentSnapshot snapshot = await collection.doc(uid).get();

      // Check if the document exists
      if (snapshot.exists) {
        // Convert the document data to JSON format
        Map<String, dynamic> jsonData = snapshot.data() as Map<String, dynamic>;

        // Add the document ID to the JSON data
        jsonData['id'] = snapshot.id;
        print(jsonData);
        print("json");
        // Return the JSON data
        setState(() {
          _donData = jsonData;
          _userName = jsonData['name'] ?? '';
          _coord = jsonData['location'];
          _address = jsonData['address'] ?? "";
          _quantity = jsonData['quantity'].toString();
          _userId = jsonData['userId'] ?? '';
          _phoneNo = jsonData['phoneNumber'] ?? '';
          _marker.add(
            Marker(
                markerId: MarkerId("1"),
                position: LatLng(_coord.latitude, _coord.longitude),
                infoWindow: InfoWindow(title: "Destination")),
          );
        });

        return jsonData;
      } else {
        // If the document does not exist, return null
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print('Error fetching document: $e');
      return null; // Return null if an error occurs
    }
  }

  loadData() async {
    Map<String, dynamic>? data =
        await fetchDocumentAsJsonByUID('Donations', widget.id);
    setState(() {
      _donData = data;
    });
    getUserCurrentLocation().then((value) async {
      print("My Current Location");
      print("${value.latitude} ${value.longitude}");

      setState(() {
        _marker.add(Marker(
            markerId: MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(title: "My Current location")));
      });
      CameraPosition cameraPosition = CameraPosition(
          zoom: 14, target: LatLng(value.latitude, value.longitude));

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> call(String number) async {
      final Uri url = Uri(scheme: "tel", path: number);
      if (!await launchUrl(url))
        print("Unable to launch Url");
      else
        launchUrl(url);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location",
          style: TextStyle(fontWeight: FontWeight.w800, fontFamily: "Inter"),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF024EA6),
        child: Column(
          children: [
            SafeArea(
              child: SizedBox(
                height: 580,
                child: GoogleMap(
                  onTap: (LatLng latlng) {
                    _marker.add(
                      Marker(
                          markerId: MarkerId("3"),
                          position: LatLng(_coord.latitude, _coord.longitude),
                          infoWindow: InfoWindow(title: "Destination")),
                    );
                    setState(() {});
                  },
                  initialCameraPosition: loc,
                  markers: Set<Marker>.of(_marker),
                  // mapType: MapType.satellite,
                  //compassEnabled: false,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
            Container(
              height: 178.4,
              width: double.infinity,
              color: const Color(0xFF024EA6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_userName}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              '${_address}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              "Items",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              'Quantity: ${_quantity.toString()} kg',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Arrival Time",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              "Soon",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 2,
                    color: Color.fromARGB(255, 78, 134, 197),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 35,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Column(
                          children: [
                            Text(
                              '${_userName ?? ''}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "Donor",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Inter",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 120.0),
                        child: IconButton(
                            onPressed: () async {
                              await call(_phoneNo);
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Drop"),
                                    content: Text(
                                        "Are you sure that you want to pickup the food from here?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(
                                              context); // Close the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Congratulations!"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "You picked up the order, Great job. Let;s deliver the order"),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        "Continue to destination"),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      // Add navigation logic here
                                                    },
                                                    child: Text("Navigate"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text("Confirm"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: IconButton(
                            onPressed: () async {
                              // Example coordinates (latitude and longitude)
                              double destinationLatitude = _coord.latitude;
                              double destinationLongitude = _coord.longitude;

                              // Construct the URL for Google Maps with the destination coordinates
                              String googleMapsUrl =
                                  'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';

                              // Check if the URL can be launched
                              if (await canLaunch(googleMapsUrl)) {
                                // Launch Google Maps with the specified URL
                                await launch(googleMapsUrl);
                              } else {
                                // Handle error if Google Maps cannot be launched
                                throw 'Could not launch $googleMapsUrl';
                              }
                            },
                            icon: const Icon(
                              Icons.navigation,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: FloatingActionButton(
          onPressed: () async {
            print("My Current Location");
            getUserCurrentLocation().then((value) async {
              print("${value.latitude} ${value.longitude}");
              _marker.add(
                Marker(
                    markerId: MarkerId("2"),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(title: "My Current location")),
              );
              CameraPosition cameraPosition = CameraPosition(
                  zoom: 16, target: LatLng(value.latitude, value.longitude));

              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
            });
            setState(() {});
          },
          child: Icon(Icons.location_disabled_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
