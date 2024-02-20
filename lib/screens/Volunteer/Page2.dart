import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Maps/volunteermaps.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Page2 extends StatefulWidget {
  const Page2(
      {super.key,
      required this.itemname,
      required this.quantity,
      required this.id,
      required this.location,
      required this.remarks,
      required this.extraData});

  final String itemname;
  final String quantity;
  final String location;
  final String id;
  final String remarks;
  final Map<dynamic, dynamic> extraData;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool _isLoading = false;

  Future<String> addDonationToCollection({
    required String donationId,
  }) async {
          var id='';
    try {
      setState(() {
        _isLoading = true;
      });
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      // Add the donation document to the Donations collection
      var pickup = await firestore.collection('Pickup').add({
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'status': 'voluntered',
        'userId': user?.uid.toString(),
        'location': await getCurrentLocation(context),
        'donationId': donationId.toString(),
      });
      id = pickup.id.toString();
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
        print(widget.extraData);

        int pickupsDone;
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        if (querySnapshot.docs.isNotEmpty) {
          // The document exists, check if the field "pickupsDone" exists

          Map<String, dynamic>? data =
              docSnapshot.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('pickupsDone')) {
            // The field "pickupsDone" exists, get its value
            pickupsDone = data['pickupsDone'] as int;
          } else {
            // The field "pickupsDone" does not exist, set it to -1 or any default value
            pickupsDone = -1;
          }
        } else {
          // The document does not exist, set pickupsDone to -1 or any default value
          pickupsDone = -1;
        }
        print(pickupsDone);

        print("pick");
        if (pickupsDone == -1) {
          // Document does not exist or pickupsDone field does not exist
          await docSnapshot.reference.set({
            'pickupsDone': 1,
            // Add more fields as needed
          });
          await docSnapshot.reference.update({
            'pickupIds': FieldValue.arrayUnion([pickup.id]),
            'updatedAt': Timestamp.now()
            // Add more fields as needed
          });
        } else {
          // Update the data in the document
          await docSnapshot.reference.update({
            'pickupIds': FieldValue.arrayUnion([pickup.id]),
            'pickupsDone': pickupsDone + 1,
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
    return id;
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
            "assets/images/Volunteer.png",
            width: double.infinity,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 30),
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
              "Quantity: ${widget.quantity}",
              style: TextStyle(fontFamily: "Inter", color: Color(0xFF666666)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 35.0),
            child: Text(
              "Organization: ",
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
          InkWell(
            onTap: () async {
               String? pickupId= await addDonationToCollection(donationId: widget.id);
              nextScreen(context, volunteerMaps(donationId: widget.id,pickupId:pickupId));
            },
            child: !_isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
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
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          )
        ])));
  }
}
