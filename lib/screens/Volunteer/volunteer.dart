import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gdsc/screens/Volunteer/Vcard.dart';
import 'package:gdsc/services/helper/formatTimestamp.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/services/providers.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class volunteer extends StatefulWidget {
  const volunteer({super.key});

  @override
  State<volunteer> createState() => _volunteerState();
}

class _volunteerState extends State<volunteer>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _newIndex = 0;
  bool _isLoading = false;
  List<Vcard> items = [];
  GeoPoint? current;

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
    if (current != null) {
      _tab(0);
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Map<String, dynamic> distance = {'distance': 'Loading...'};

  Future<List<Vcard>> fetchDonations() async {
    List<Vcard> notificationItems = [];

    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Donations').get();

      querySnapshot.docs.forEach((doc) {
        Timestamp timestamp = doc['createdAt'];
        Map<String, String> timestamp_format = formatDateAndTime(timestamp);
        print(timestamp_format['date']!);
        // String date = formatDate(timestamp);
        // String heading = doc['title'];
        // String content = doc['message'];
        // String time = timestamp_format['time']!;
        print(doc.data());
        print(doc.id);
        print("id");
        Vcard item = Vcard(
            item: doc['itemname'] ?? '',
            quantity: doc['quantity'] ??
                '0', // Use null-aware operator to handle null quantity
            location: doc['address'] ??
                '', // Use null-aware operator to handle null address
            id: doc.id,
            extraData: doc.data());
        print(item);
        notificationItems.add(item);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $error');
      // Handle error gracefully
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    return notificationItems;
  }

  Future<void> fetchData() async {
    GeoPoint? currentLoc = await context.read<Providers>().current_loc_data;

    setState(() {
      fetchDonations().then((value) => {items = value});
      print(currentLoc!.latitude.toString());
      print("fetch current loc");
    });
    setState(() {
      current = currentLoc;
    });
  }

  Widget _tab(int index) {
    double Width = MediaQuery.of(context).size.width; // Gives the width
    setState(() {
      _isLoading = true;
      // GeoPoint? curr = await getCurrentLocation();
      // current = curr;
    });
    List<Vcard> VCard1 = [];
    List<Vcard> VCard2 = [];
    List<Vcard> VCard3 = [];
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      GeoPoint? loc = item.extraData['location'] ?? current;
      // print("loc");
      // print(context.read<Providers>().current_loc_data?.latitude);
      //       print(context.read<Providers>().current_loc_data?.longitude);
      // print(loc?.latitude);
      // print(loc?.longitude);
      double distance = calculateDistanceNew(
           context.read<Providers>().current_loc_data?.latitude, context.read<Providers>().current_loc_data?.longitude, loc?.latitude, loc?.longitude);
      // print(distance);

      item.distance = distance;
      if (distance < 2) {
        VCard1.add(item);
      } else if (distance >= 2 && distance < 5) {
        VCard2.add(item);
      } else if (distance >= 5) {
        VCard3.add(item);
      }
    }

//     // Sort VCard1 list
    VCard1.sort((a, b) => a.distance.compareTo(b.distance));

// Sort VCard2 list
    VCard2.sort((a, b) => a.distance.compareTo(b.distance));

// Sort VCard3 list
    VCard3.sort((a, b) => a.distance.compareTo(b.distance));

    List<Widget> parsedWidgets = [];
    if (index == 0)
      for (int i = 0; i < VCard1.length; i++) {
        parsedWidgets.add(SingleChildScrollView(
          child: VCard1[i],
        ));
      }
    else if (index == 1)
      for (int i = 0; i < VCard2.length; i++) {
        parsedWidgets.add(SingleChildScrollView(
          child: VCard2[i],
        ));
      }
    else if (index == 2)
      for (int i = 0; i < VCard3.length; i++) {
        parsedWidgets.add(SingleChildScrollView(
          child: VCard3[i],
        ));
      }
    setState(() {
      _isLoading = false;
    });

    return ListView(
      children: parsedWidgets.length > 0
          ? parsedWidgets
          : [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No data available now'),
              ))
            ],
    );
  }

  double calculateDistance(GeoPoint point1, GeoPoint point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1 = radians(point1.latitude);
    double lon1 = radians(point1.longitude);
    double lat2 = radians(point2.latitude);
    double lon2 = radians(point2.longitude);

    // Calculate the differences between the latitudes and longitudes
    double dLat = (lat2 - lat1).abs();
    double dLon = (lon2 - lon1).abs();

    // Apply the Haversine formula
    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    // Return the distance rounded to 2 decimal places
    return double.parse(distance.toStringAsFixed(2));
  }

  double calculateDistanceNew(lat1, lon1, lat2, lon2) {
    print(lat1);
    print(lon1);
    print(lat2);
    print(lon2);
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double radians(double degrees) {
    return degrees * (pi / 180);
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
              // color: Color.fromRGBO(78, 134, 199, 0.83),
            ),
            height: 50,
            child: const Center(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 8, height: 8),
                    Text("Volunteer Page",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        )),
                    Text("Pick from locations and drop at nearby points",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 102, 98, 88))),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                  "5+ km",
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
      body: !_isLoading
          ? TabBarView(
              controller: _tabController,
              children: [
                _tab(0),
                _tab(1),
                _tab(2),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
