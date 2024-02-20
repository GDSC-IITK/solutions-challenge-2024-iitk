import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/Page7.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Maps extends StatefulWidget {
  const Maps(
      {super.key,
      required this.donationId,
      required this.pickupId,
      required this.location});

  final String donationId;
  final String pickupId;
  final GeoPoint location;
  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  Map<String, dynamic> _donationData = {};
  static CameraPosition loc =
      const CameraPosition(target: LatLng(26.511639, 80.230954), zoom: 14);
  Future<Map<String, dynamic>?> getDocumentDataById(
      String collectionName, String documentId) async {
    try {
      // Reference to the Firestore collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      // Get the document snapshot using its ID
      DocumentSnapshot snapshot = await collection.doc(documentId).get();

      // Check if the document exists
      if (snapshot.exists) {
        // Extract data from the document snapshot
        Map<String, dynamic> documentData =
            snapshot.data() as Map<String, dynamic>;
        setState(() {
          _donationData = documentData;
        });
        // Return the document data
        return documentData;
      } else {
        // Document does not exist
        print('Document does not exist');
        return null;
      }
    } catch (error) {
      // Handle any errors that might occur
      print('Error fetching document data: $error');
      return null; // Return null in case of error
    }
  }

  List<Marker> _marker = [];
  final List<Marker> _list = [
    const Marker(
        markerId: MarkerId("1"),
        position: LatLng(26.514323, 80.231223),
        infoWindow: InfoWindow(title: "Current position"))
  ];

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    loadData();
    getDocumentDataById('Donations', widget.donationId ?? '');
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  loadData() {
    getUserCurrentLocation().then((value) async {
      print("My Current Location");
      print("${value.latitude} ${value.longitude}");
      _marker.add(
        Marker(
            markerId: MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(title: "My Current location")),
      );
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
        title: Text("Location"),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                          position: latlng,
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Drop Point",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              "Donor's address",
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
                              "Quantity: 10 kgs",
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
                              "5-8 min",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                       Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirm Drop"),
                                              content: Text(
                                                  "Are you sure that you want to drop the food here to the receiver?"),
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
                                                      builder:
                                                          (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              "Congratulations!"),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "To complete the drop, please continue"),
                                                              SizedBox(height: 10),
                                                              Text(""),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context); // Close the dialog
                                                                // Add navigation logic here
                                                                nextScreen(
                                                                    context,
                                                                    Page7(
                                                                      donationId:
                                                                          widget
                                                                              .donationId,
                                                                      pickupId: widget
                                                                          .pickupId,
                                                                      dropLocation: widget.location
                                                                    ));
                                                              },
                                                              child:
                                                                  Text("Continue"),
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
                                      Text('Drop Food here',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: IconButton(
                            onPressed: () async {
                              // Example coordinates (latitude and longitude)
                              double destinationLatitude =
                                  widget.location.latitude;
                              double destinationLongitude =
                                  widget.location.longitude;

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
