import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/screens/Donate/donate_3.dart';
import 'package:gdsc/screens/Donate/uploadDonateImage.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class IndividualDonateContainer extends StatefulWidget {
  const IndividualDonateContainer({Key? key}) : super(key: key);

  @override
  State<IndividualDonateContainer> createState() =>
      _IndividualDonateContainerState();
}

class _IndividualDonateContainerState extends State<IndividualDonateContainer> {
  String _selectedValue = 'Option 1';
  TextEditingController itemname = TextEditingController();
  TextEditingController itemndesc = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController organization = TextEditingController();

  List<String> _options = [
    'in Kilograms(kg)',
    'in Liters(l)',
    'in Pounds(lb)',
    'in Ounces(oz)',
    'in Pieces'
  ];
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String _UserName = "";
  String _UserId = "";
  String _userMail = "";
  String _downloadLink = "";
  @override
  void initState() {
    super.initState();
    _selectedValue = _options.first;
    _loadUserName();
  }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
    _uploadImageToFirebaseStorage(image, "Donations", _UserName)
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
    _uploadImageToFirebaseStorage(image, "Users", _UserName);
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

  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;

    return Container(
        child: Column(children: [
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child:
              Image.asset('assets/images/individual_donate_page_picture.png')),
      const SizedBox(
        height: 10,
      ),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Full Name",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: organization,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            )
          ])),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Item Name",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: itemname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            )
          ])),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Item Description",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: itemndesc,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            )
          ])),
      Center(
          child: Container(
              child: Row(children: <Widget>[
        Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity",
                          style: GoogleFonts.inter(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: quantity,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ]))),
        Container(
            alignment: Alignment.centerLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 25,
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
                  child: DropdownButton<String>(
                      value: _selectedValue,
                      items: _options.map((value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      }),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ]))
      ]))),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Address",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: location,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
          ])),
      Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () async {
            setState(() {
              // Set a loading indicator while fetching the location
              location.text =
                  "Fetching location..."; // or any other loading message
            });
            GeoPoint? currentLocation = await getCurrentLocation();
            if (currentLocation != null) {
              location.text = await getLocationFromGeoPoint(currentLocation);
            } else {
              setState(() {
                // Handle the case where getCurrentLocation() returns null
                // For example, display an error message or provide a default location
                location.text = "Unable to fetch location";
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Continue with current location', // This will display either the loading message or the fetched location
              style: GoogleFonts.inter(
                color: Color.fromRGBO(102, 102, 102, 0.7),
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Comments",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: remarks,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
          ])),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
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
            // Upload image to Firebase Storage
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(199, 255, 255, 255),
              shape: BoxShape.circle,
              // Add boxShadow if needed
              // boxShadow: [
              //   BoxShadow(
              //     offset: Offset(0, 4),
              //     blurRadius: 4,
              //     color: Color(0xFF000000),
              //     spreadRadius: 0.8,
              //   ),
              // ],
            ),
            child: GestureDetector(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 255,
                        255), // Change the color to match your app's theme
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white12,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      // SizedBox(width: 10),
                      Text(
                        '${_downloadLink==''?'Upload Image':'Upload Another Image'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {
          if (itemname.text != '' &&
              quantity.text != '' &&
              location.text != '' &&
              remarks.text != '' &&
              organization.text != '' &&
              itemndesc.text != '') {
            // Check if organization is not required or is not null when donating as an organization
            nextScreen(
              context,
              Donate_3(
                  imageUrl: _downloadLink.toString(),
                  type: 'individual',
                  weightMetric: _selectedValue,
                  itemname: itemname.text!,
                  quantity: quantity.text!,
                  location: location.text!,
                  remarks: remarks.text!,
                  organization: organization.text!,
                  itemdesc: itemndesc.text!),
            );
          } else {
            // Show a snackbar or any other feedback to indicate missing fields
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please fill in all the required fields.'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(2, 78, 166, 1),
              ),
              width: Width / 1.1,
              height: 50,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: !_isLoading?Text(
                  "Continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Inter"),
                ):Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      )
    ]));
  }
}
