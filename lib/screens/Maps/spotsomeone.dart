import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class spotSomeone extends StatefulWidget {
  const spotSomeone({super.key});

  @override
  State<spotSomeone> createState() => spotSomeoneState();
}

class spotSomeoneState extends State<spotSomeone> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition loc =
      const CameraPosition(target: LatLng(26.511639, 80.230954), zoom: 14);

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
        title: Text(
          "Spot Someone in Need",
          style: TextStyle(fontFamily: "Inter"),
        ),
      ),
      body: Column(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Color.fromARGB(255, 72, 129, 194)),
                      height: 49,
                      width: 311,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              size: 20,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Add Landmark",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Inter",
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Color.fromARGB(255, 72, 129, 194)),
                      height: 49,
                      width: 311,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Continue to add images",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Inter",
                                    fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
