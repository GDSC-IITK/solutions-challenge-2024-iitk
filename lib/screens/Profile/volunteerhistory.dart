import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/services/providers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class volunteerhistory extends StatefulWidget {
  const volunteerhistory({super.key});

  @override
  State<volunteerhistory> createState() => _volunteerhistoryState();
}

class Volunteering {
  final String id;
  final Map<String, dynamic> data;

  Volunteering({required this.id, required this.data});
}

class _volunteerhistoryState extends State<volunteerhistory> {
  List<Volunteering> userVolunteerings = [];

  Future<List<Volunteering>> fetchUserVolunteerings() async {
    List<Volunteering> userVolunteerings = [];

    try {
      // Get the current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      print(userId);
      print("user id");
      if (userId != null) {
        // Fetch documents from the "Volunteerings" collection where "userId" matches the current user's ID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Pickup')
            .where('userId', isEqualTo: userId)
            .get();

        // Iterate through the documents and store them as Volunteering objects
        querySnapshot.docs.forEach((doc) {
          String donationId = doc.id;
          Map<String, dynamic> donationData =
              doc.data() as Map<String, dynamic>;
          Volunteering donation =
              Volunteering(id: donationId, data: donationData);
          userVolunteerings.add(donation);
        });
      } else {
        print('User is not logged in.');
      }
    } catch (error) {
      print('Error fetching user donations: $error');
    }
    print(userVolunteerings[0].data);
    return userVolunteerings;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserVolunteerings().then((donations) {
      setState(() {
        userVolunteerings = donations;
      });
    });
  }

  Future<String> getLocationFromGeoPoint(GeoPoint geoPoint) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geoPoint.latitude,
        geoPoint.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return placemark.street ?? 'N/A';
      } else {
        return 'N/A';
      }
    } catch (e) {
      print('Error getting location: $e');
      return 'N/A';
    }
  }

  Future<List<Widget>> _buildVolunteeringWidgets() async {
    List<Widget> widgets = [];
    for (var userVolunteering in userVolunteerings) {
      String location =
          await getLocationFromGeoPoint(userVolunteering.data['location']);
      widgets.add(
        Container(
          height: 115,
          padding: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Donation Id: ${userVolunteering.data['donationId'] ?? 'N/A'}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Status: ${userVolunteering.data['status'] ?? ''}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Location: $location", // Use the fetched location here
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Remarks: ${userVolunteering.data['comment'] ?? 'N/A'}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Date: ${userVolunteering.data['updatedAt'] != null ? DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(userVolunteering.data['updatedAt'].millisecondsSinceEpoch)) : 'N/A'}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              height: 128,
              decoration: const BoxDecoration(color: Color(0xFF024EA6)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(context
                          .read<Providers>()
                          .user_data
                          .toJson()['profileImageLink']
                          .toString()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context
                              .read<Providers>()
                              .user_data
                              .toJson()['fullName']
                              .toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Inter",
                              color: Color.fromARGB(199, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${context.read<Providers>().user_data.toJson()['userName'].toString()}",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color.fromARGB(199, 255, 255, 255),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
          AppBar(
            title: const Text(
              "Pickup History",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 15, right: 15),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FutureBuilder<List<Widget>>(
                  future: _buildVolunteeringWidgets(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting for data
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error: ${snapshot.error}'); // Show an error message if an error occurred
                    } else {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No Data to Show',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                // Add padding between each list item
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: snapshot.data![index],
                                );
                              },
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
