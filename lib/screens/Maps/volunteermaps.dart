import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/screens/Volunteer/map_animation_page.dart';
import 'package:gdsc/services/helper/getLocationfromGeopoint.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class volunteerMaps extends StatefulWidget {
  const volunteerMaps({
    super.key,
    required this.donationId,
    required this.pickupId,
  });
  final String donationId;
  final String pickupId;

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
  GeoPoint _current = GeoPoint(0, 0);

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
          print(jsonData);
          _marker.add(
            Marker(
                markerId: const MarkerId("1"),
                position: LatLng(_coord.latitude, _coord.longitude),
                infoWindow: const InfoWindow(title: "Destination")),
          );
        });
        CameraPosition cameraPosition = CameraPosition(
            zoom: 16, target: LatLng(_coord.latitude, _coord.longitude));

        final GoogleMapController controller = await _controller.future;
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

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
        await fetchDocumentAsJsonByUID('Donations', widget.donationId);
    setState(() {
      _donData = data;
    });
    getUserCurrentLocation().then((value) async {
      print("My Current Location");
      print("${value.latitude} ${value.longitude}");
      Uint8List? markerIcon = await createCurrentLocationMarker();

      setState(() {
        _current = GeoPoint(value.latitude, value.longitude);
        _marker.add(Marker(
            markerId: const MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            icon: BitmapDescriptor.fromBytes(markerIcon!),
            infoWindow: const InfoWindow(title: "My Current location")));
      });
    });
    setState(() {});
  }

  Future<Uint8List?> createCurrentLocationMarker() async {
    final double markerSize = 80.0; // Adjust the size of the marker as needed

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paintCircle = Paint()
      ..color = Colors.blue; // Blue color for the circle

    // Draw the circle for the marker
    canvas.drawCircle(
      Offset(markerSize / 2, markerSize / 2), // Center of the circle
      markerSize / 2, // Radius of the circle
      paintCircle,
    );

    // Convert the canvas to an image
    final img = await pictureRecorder
        .endRecording()
        .toImage(markerSize.toInt(), markerSize.toInt());
    final imgByteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return imgByteData?.buffer.asUint8List();
  }

  Future<void> updateDonationStatus(String donationId) async {
    try {
      // Reference to the document in the "Donations" collection
      DocumentReference donationRef =
          FirebaseFirestore.instance.collection('Donations').doc(donationId);

      // Fetch the document snapshot
      DocumentSnapshot donationSnapshot = await donationRef.get();

      // Check if the document exists
      if (donationSnapshot.exists) {
        // Update the status field to 'pickedUp'
        await donationRef.update({'status': 'pickedUp'});
        print('Donation status updated successfully.');
      } else {
        print('Document does not exist.');
      }
    } catch (error) {
      print('Error updating donation status: $error');
    }
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
        title: const Text(
          "Location",
          style: TextStyle(fontWeight: FontWeight.w800, fontFamily: "Inter"),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF024EA6),
        child: Column(
          children: [
            SafeArea(
              child: SizedBox(
                height: 570,
                child: GoogleMap(
                  onTap: (LatLng latlng) {
                    _marker.add(
                      Marker(
                          markerId: const MarkerId("3"),
                          position: LatLng(_coord.latitude, _coord.longitude),
                          infoWindow: const InfoWindow(title: "Destination")),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_userName}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                '${_address}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Details",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            const Text(
                              "Items",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            Text(
                              'Quantity: ${_quantity.toString()} kg',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const Padding(
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
                    color: const Color.fromARGB(255, 78, 134, 197),
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
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          children: [
                            Text(
                              '${_userName ?? ''}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            const Text(
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
                        padding: const EdgeInsets.only(left: 80.0),
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
                              if (calculateDistanceNew(
                                      _current.latitude,
                                      _current.longitude,
                                      _coord.latitude,
                                      _coord.longitude) >
                                  0.1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'You are far from the pickup point. Please get close.'),
                                  ),
                                );
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Pickup"),
                                    content: const Text(
                                        "Are you sure that you want to pickup the food from here?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(
                                              context); // Close the dialog
                                          await updateDonationStatus(
                                              widget.donationId);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Congratulations!"),
                                                content: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "You picked up the order, Great job. Let's deliver the order"),
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
                                                          MapAnimationPage(
                                                              donationId: widget
                                                                      .donationId ??
                                                                  '',
                                                              pickupId: widget
                                                                      .pickupId ??
                                                                  ''));
                                                    },
                                                    child: Text("Continue"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text("Confirm"),
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
            print("Destination Location");
            _marker.add(
              Marker(
                  markerId: const MarkerId("2"),
                  position: LatLng(_coord.latitude, _coord.longitude),
                  infoWindow: const InfoWindow(title: "Destination location")),
            );
            CameraPosition cameraPosition = CameraPosition(
                zoom: 16, target: LatLng(_coord.latitude, _coord.longitude));

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            // getUserCurrentLocation().then((value) async {
            //   print("${value.latitude} ${value.longitude}");

            // });
            setState(() {});
          },
          child: const Icon(Icons.location_disabled_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
