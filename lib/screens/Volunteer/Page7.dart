import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Page7 extends StatefulWidget {
  const Page7(
      {super.key,
      required this.donationId,
      required this.pickupId,
      required this.dropLocation});
  final String donationId;
  final String pickupId;
  final GeoPoint dropLocation;
  @override
  State<Page7> createState() => _Page7State();
}

class _Page7State extends State<Page7> {
  TextEditingController feedbackController = TextEditingController();

  TextEditingController noOfPeopleServedController = TextEditingController();

  TextEditingController receiverFeedbackController = TextEditingController();
  TextEditingController receiverAgeGroupController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String _UserName = "";
  String _UserId = "";
  String _userMail = "";
  String _downloadLink = "";
  bool areTextFieldsNotEmpty() {
    return feedbackController.text.isNotEmpty &&
        noOfPeopleServedController.text.isNotEmpty &&
        receiverFeedbackController.text.isNotEmpty &&
        receiverAgeGroupController.text.isNotEmpty &&
        receiverNameController.text.isNotEmpty;
  }

  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
    _uploadImageToFirebaseStorage(image, "Drop", _UserName)
        .then((value) => null);
  }

  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String id = user.uid ?? "";
      Map<String, String> userData = await fetchDataByUID(id);
      print(userData);
      print("user data");
      setState(() {
        _UserName = userData['userName'] ?? '';
        _UserId = user.uid;
        if (user.email!.isNotEmpty) {
          _userMail = user.email!;
        } else {
          _userMail = userData['email'] ?? '';
        }
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
    _uploadImageToFirebaseStorage(image, "Drop", _UserName);
  }

  Future<String> _uploadImageToFirebaseStorage(
      XFile? _imageFile, folder, name) async {
    print("uploading image");
    if (_imageFile != null) {
      try {
        _isLoading = true;
        // Upload the image to Firebase Storage
        print(_imageFile);
        print("image file");
        final firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(
                '${folder}/${_UserId}_${DateTime.now().millisecondsSinceEpoch}');
        print(ref);
        print("ref");
        await ref.putFile(File(_imageFile!.path));
        // Get the download URL of the uploaded image
        String downloadURL = await ref.getDownloadURL();
        // TODO: Save the download URL to user's profile data
        print('Image uploaded to Firebase Storage: $downloadURL');
        setState(() {
          _isLoading = false;
          _downloadLink = downloadURL;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded')),
        );
        return downloadURL;
        // final QuerySnapshot emailQuery = await FirebaseFirestore.instance
        //     .collection("Users")
        //     .where("email", isEqualTo: _userMail)
        //     .get();
        // print(_userMail);
        // print("email query");
        // await emailQuery.docs.first.reference.update(
        //     {'profileImageLink': downloadURL, 'updatedAt': Timestamp.now()});
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print('Error uploading image to Firebase Storage: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image to be uploaded is null')),
      );
    }
    return '';
  }

  Future<String> getLocationFromGeoPoint(GeoPoint geoPoint) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geoPoint.latitude,
        geoPoint.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String street = placemark.street ?? 'N/A';
        String city = placemark.locality ?? 'N/A';
        String state = placemark.administrativeArea ?? 'N/A';
        String country = placemark.country ?? 'N/A';

        // Concatenate the address components
        String fullAddress = '$street, $city, $state, $country';

        return fullAddress;
      } else {
        return 'N/A';
      }
    } catch (e) {
      print('Error getting location: $e');
      return 'N/A';
    }
  }

  Future<Map<String, dynamic>?> fetchDocumentByDonationId(
      String collectionName, String param) async {
    try {
      // Get reference to the collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      // Get the document by donationId
      DocumentSnapshot documentSnapshot = await collection.doc(param).get();

      // Convert the DocumentSnapshot to a map
      Map<String, dynamic>? documentData =
          documentSnapshot.data() as Map<String, dynamic>?;

      // Return the document data map
      return documentData;
    } catch (error) {
      // Handle any errors that might occur
      print('Error fetching document: $error');
      return null; // Return null in case of error
    }
  }

  Future<void> submitData() async {
    if (_downloadLink == '') {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text('Please add an image to continue'),
        ),
      );
      return;
    }
    if (areTextFieldsNotEmpty()) {
      // Perform your work here
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String id = user.email ?? "";
        CollectionReference users =
            FirebaseFirestore.instance.collection('Users');

        QuerySnapshot querySnapshot =
            await users.where('email', isEqualTo: id).get();
        int donationsDone = querySnapshot.docs.first.get('dropsDone') ?? 0;

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;

          // Update the data in the document
          await docSnapshot.reference.update({
            // Specify the fields you want to update along with their new values
            // For example:
            'dropsIds': FieldValue.arrayUnion([widget.donationId]),
            'dropsDone': donationsDone + 1,
            'updatedAt': Timestamp.now()
            // Add more fields as needed
          });
          Map<String, dynamic>? donationData =
              await fetchDocumentByDonationId('Donations', widget.donationId);
          Map<String, dynamic>? pickupData =
              await fetchDocumentByDonationId('Pickup', widget.pickupId);
          GeoPoint? currentLocation = await getCurrentLocation(context);

          var payload = {
            'donationData': donationData ?? {},
            'pickupData': pickupData ?? {},
            'donationId': widget.donationId,
            'pickupId': widget.pickupId,
            'dropLocationActual': widget.dropLocation,
            'dropLocationReal': currentLocation,
            'dropLocationActualAddress':
                await getLocationFromGeoPoint(widget.dropLocation),
            'dropLocationRealAddress': await getLocationFromGeoPoint(currentLocation!),
            'feedback': feedbackController.text,
            'noOfPeopleServed': noOfPeopleServedController.text,
            'receiverFeedback': receiverFeedbackController.text,
            'receiverAgeGroup': receiverAgeGroupController.text,
            'receiverName': receiverNameController.text,
            'imageLink': _downloadLink,
            'userId': user.uid,
            'likes':0,
            'createdAt':Timestamp.now(),
            'updatedAt':Timestamp.now()
          };
          print(payload);
          var drop = await firestore.collection('HomePage').add(payload);
          CollectionReference users =
              FirebaseFirestore.instance.collection('Users');

          int dropsDone = querySnapshot.docs.first.get('dropsDone') ?? 0;

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot docSnapshot = querySnapshot.docs.first;

            // Update the data in the document
            await docSnapshot.reference.update({
              // Specify the fields you want to update along with their new values
              // For example:
              'dropIds': FieldValue.arrayUnion([drop.id]),
              'dropsDone': dropsDone + 1,
              'updatedAt': Timestamp.now()
              // Add more fields as needed
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green, // Set background color to green
              content: Text(
                'Your post was successfully saved',
                style:
                    TextStyle(color: Colors.black), // Set text color to black
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          nextScreenReplace(context, HomePage());
        }
      }
    } else {
      // Handle case when text fields are empty
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(
              'Please fill all the fields. Write N/A in that which do not apply'),
        ),
      );
      print('One or both text fields are empty. Cannot proceed with the work.');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: const Color.fromARGB(250, 67, 121, 184),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 80, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a Post",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              Text(
                "continue to leave feedback",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(170, 255, 255, 255),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  // add image
                  // Show dialog to select camera or gallery
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Change Profile Image'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Take Photo'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _getImageFromCamera();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.of(context).pop();
                                _getImageFromGallery();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                label: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          value: null,
                          semanticsLabel: "Loading",
                        ),
                      ) // Show loader when isLoading is true
                    : Text(
                        '${_downloadLink == '' ? 'Add Image' : 'Add Other Image'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Color.fromARGB(130, 2, 79, 166),
                ),
              ),

              SizedBox(height: 20),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     //  add location
              //   },
              //   icon: Padding(
              //     padding: const EdgeInsets.only(left: 8.0),
              //     child: Icon(
              //       Icons.location_on,
              //       color: Colors.white,
              //     ),
              //   ),
              //   label: Row(
              //     children: [
              //       Text(
              //         "Add Location",
              //         style: TextStyle(
              //           color: Colors.white,
              //         ),
              //       ),
              //     ],
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(7.0),
              //     ),
              //     padding: EdgeInsets.symmetric(vertical: 20),
              //     minimumSize: Size(double.infinity, 0),
              //     backgroundColor: Color.fromARGB(252, 132, 173, 219),
              //   ),
              // ),
              SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: "Feedback",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(252, 132, 173, 219)),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(252, 132, 173, 219), width: 2.0),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 10),
              TextField(
                controller: noOfPeopleServedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "No of people served",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(252, 132, 173, 219)),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(252, 132, 173, 219), width: 2.0),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),

              TextField(
                controller: receiverFeedbackController,
                decoration: InputDecoration(
                  labelText: "Receiver's Feedback",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(252, 132, 173, 219)),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(252, 132, 173, 219), width: 2.0),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),

              TextField(
                controller: receiverNameController,
                decoration: InputDecoration(
                  labelText: "Receiver's Name (or names)",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(252, 132, 173, 219)),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(252, 132, 173, 219), width: 2.0),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),

              TextField(
                controller: receiverAgeGroupController,
                decoration: InputDecoration(
                  labelText: "Receiver's Approximate Age (or age group)",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(252, 132, 173, 219)),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(252, 132, 173, 219), width: 2.0),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  submitData();
                },
                child: Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  minimumSize: Size(double.infinity, 0),
                  backgroundColor: Color.fromARGB(252, 132, 173, 219),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
