import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/services/providers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class donatehistory extends StatefulWidget {
  const donatehistory({super.key});

  @override
  State<donatehistory> createState() => _donatehistoryState();
}

class Donation {
  final String id;
  final Map<String, dynamic> data;

  Donation({required this.id, required this.data});
}

class _donatehistoryState extends State<donatehistory> {
  List<Donation> userDonations = [];

  Future<List<Donation>> fetchUserDonations() async {
    List<Donation> userDonations = [];

    try {
      // Get the current user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      print(userId);
      print("user id");
      if (userId != null) {
        // Fetch documents from the "Donations" collection where "userId" matches the current user's ID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Donations')
            .where('userId', isEqualTo: userId)
            .get();

        // Iterate through the documents and store them as Donation objects
        querySnapshot.docs.forEach((doc) {
          String donationId = doc.id;
          Map<String, dynamic> donationData =
              doc.data() as Map<String, dynamic>;
          Donation donation = Donation(id: donationId, data: donationData);
          userDonations.add(donation);
        });
      } else {
        print('User is not logged in.');
      }
    } catch (error) {
      print('Error fetching user donations: $error');
    }
    print(userDonations[0].data);
    return userDonations;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserDonations().then((donations) {
      setState(() {
        userDonations = donations;
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

  Future<List<Widget>> _buildDonationWidgets() async {
    List<Widget> widgets = [];
    for (var userDonation in userDonations) {
      String location =
          await getLocationFromGeoPoint(userDonation.data['address']);
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
                "Organisation name: ${userDonation.data['donatorName'] ?? 'N/A'}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Quantity: ${userDonation.data['quantity'] ?? 'N/A'}" +
                    " ${userDonation.data['weightMetric'] ?? ''}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Location: $location", // Use the fetched location here
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Remarks: ${userDonation.data['comment'] ?? 'N/A'}",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),
              Text(
                "Date: ${userDonation.data['updatedAt'] != null ? DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(userDonation.data['updatedAt'].millisecondsSinceEpoch)) : 'N/A'}",
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
              "Donation History",
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
                  future: _buildDonationWidgets(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting for data
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
                          child: ListView(
                            children: snapshot.data!,
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
