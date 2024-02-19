import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/screens/Donate/donation_confirmed.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Donate_3 extends StatefulWidget {
  const Donate_3(
      {super.key,
      required this.imageUrl,
      required this.type,
      required this.weightMetric,
      required this.itemname,
      required this.quantity,
      required this.location,
      required this.remarks,
      required this.organization,
      required this.itemdesc});

  final String imageUrl;
  final String weightMetric;
  final String itemname;
  final String quantity;
  final String location;
  final String remarks;
  final String organization;
  final String itemdesc;
  final String type;

  @override
  State<Donate_3> createState() => _Donate_3State();
}

class _Donate_3State extends State<Donate_3> {
  bool _isLoading = false;
  Future<void> addDonationToCollection({
    required String itemname,
    required String quantity,
    required String location,
    required String remarks,
    required String organization,
    required String itemdesc,
    required String weightMetric,
    required String type,
    required String imageUrl,
  }) async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      final QuerySnapshot emailQuery = await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: user?.email ?? '')
          .get();

      final QuerySnapshot phoneNumberQuery = await FirebaseFirestore.instance
          .collection("Users")
          .where("phoneNumber", isEqualTo: user?.phoneNumber ?? '')
          .get();
      // Add the donation document to the Donations collection
      String phone = '';
      if (emailQuery.docs.first.exists) {
        phone = emailQuery.docs.isNotEmpty &&
                (emailQuery.docs.first.data() as Map<String, dynamic>)
                    .containsKey('phoneNumber')
            ? emailQuery.docs.first.get('phoneNumber')
            : "";
      }
      else if (phoneNumberQuery.docs.first.exists) {
        phone = phoneNumberQuery.docs.isNotEmpty &&
                (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                    .containsKey('phoneNumber')
            ? phoneNumberQuery.docs.first.get('phoneNumber')
            : "";
      }
      var donation = await firestore.collection('Donations').add({
        'itemname': itemname,
        'quantity': int.parse(quantity),
        'address': location,
        'remarks': remarks,
        'name': organization,
        'itemdesc': itemdesc,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'status': 'posted',
        'availableTime': 180,
        'donatorName': user?.displayName,
        'isIndividual': false,
        'userId': user?.uid,
        'location': await getCurrentLocation(),
        'weightMetric': weightMetric,
        'type': type,
        'imageUrl': imageUrl,
        'phoneNumber': user?.phoneNumber!=null ? user?.phoneNumber : phone,
      });
      // await firestore.collection('HomePage').add({
      //   'itemname': itemname,
      //   'quantity': int.parse(quantity),
      //   'address': location,
      //   'remarks': remarks,
      //   'name': organization,
      //   'itemdesc': itemdesc,
      //   'createdAt': Timestamp.now(),
      //   'updatedAt': Timestamp.now(),
      //   'status': 'posted',
      //   'availableTime': 180,
      //   'donatorName': user?.displayName,
      //   'isIndividual': false,
      //   'userId': user?.uid,
      //   'location': await getCurrentLocation(),
      //   'weightMetric': weightMetric,
      //   'type': type,
      //   'imageUrl': imageUrl,
      //   'likes': 0,
      //   'type': 'donate',
      // });
      if (user != null) {
        String id = user.email ?? "";
        CollectionReference users =
            FirebaseFirestore.instance.collection('Users');

        QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: id).get();
        int donationsDone = querySnapshot.docs.first.get('donationsDone') ?? 0;

        if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot docSnapshot = querySnapshot.docs.first;

          // Update the data in the document
          await docSnapshot.reference.update({
            // Specify the fields you want to update along with their new values
            // For example:
            'donationIds': FieldValue.arrayUnion([donation.id]),
            'donationsDone': donationsDone + 1,
            'updatedAt': Timestamp.now()
            // Add more fields as needed
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle any errors that occur during the process
      print('Error adding donation to collection: $e');
      throw e; // Rethrow the error to handle it elsewhere if needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset(
            "assets/images/donation_confirm.png",
            width: double.infinity,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30, bottom: 10),
            child: Text(
              "Details",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Inter"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Item's name: ${widget.itemname}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Item's description: ${widget.itemdesc}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Quantity: ${widget.quantity}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Organization: ${widget.organization}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Location: ${widget.location}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Remarks: ${widget.remarks}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Image Uploaded: ${widget.imageUrl != '' ? 'Yes' : 'No'}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          InkWell(
            onTap: () async {
              await addDonationToCollection(
                  imageUrl: widget.imageUrl,
                  weightMetric: widget.weightMetric,
                  itemdesc: widget.itemdesc,
                  itemname: widget.itemname,
                  quantity: widget.quantity,
                  organization: widget.organization,
                  location: widget.location,
                  type: widget.type,
                  remarks: widget.remarks);
              nextScreen(context, DonationConfirmPage());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: !_isLoading
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(2, 78, 166, 1),
                        ),
                        width: Width / 1.1,
                        height: 50,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Confirm",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: "Inter"),
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          )
        ])));
  }
}
