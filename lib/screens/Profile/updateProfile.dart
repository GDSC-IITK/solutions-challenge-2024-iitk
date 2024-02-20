import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/function/generateUserName.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc/screens/Profile/profileImage.dart';
import 'package:gdsc/services/database_services.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/services/providers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class updateProfile extends StatefulWidget {
  const updateProfile({Key? key}) : super(key: key);

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  TextEditingController c4 = TextEditingController();
  TextEditingController c5 = TextEditingController();
  TextEditingController c6 = TextEditingController();

  String _userMail = "";
  String _UserName = "";
  String _fullName = "";
  String _phoneNo = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Function to load user's name from Firebase
  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user?.email);
    print("user");
    if (user != null) {
      setState(() {
        _userMail = user.email ?? "";
      });
      Map<String, String> userData = await fetchData(_userMail);
      print(userData);
      setState(() {
        _UserName = userData['userName'] ?? '';
        _fullName = userData['fullName'] ?? '';
        c1.text = userData['fullName'] ?? '';
        c2.text = userData['phoneNumber'] ?? '';
        c3.text = userData['age'] ?? '';
        c4.text = userData['address'] ?? '';
        c5.text = userData['dateOfBirth'] ?? '';
        c6.text = _userMail;
        _phoneNo = userData['phoneNumber'] ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (c1.text.isEmpty ||
          c2.text.isEmpty ||
          c3.text.isEmpty ||
          c4.text.isEmpty ||
          c5.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all the fields')),
        );
        return;
      }

      if (c2.text.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill 10 digit phone number')),
        );
        return;
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      print(_userMail);
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: _userMail).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first document found with the provided email
        await querySnapshot.docs.first.reference.update({
          'fullName': c1.text,
          'phoneNumber': c2.text,
          'age': int.parse(c3.text),
          'address': c4.text,
          'dateOfBirth': c5.text,
          'currentLocation': getCurrentLocation(),
          'updatedAt': Timestamp.now()
        });

        // Show a success message or perform any other action upon successful update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        // Add a new document with the provided data since user document is not found
        DocumentReference newUserRef =
            await FirebaseFirestore.instance.collection('Users').add({
          'fullName': c1.text,
          'phoneNumber': c2.text,
          'email': _userMail,
          'age': int.parse(c3.text),
          'address': c4.text,
          'dateOfBirth': c5.text,
          'currentLocation': getCurrentLocation(),
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
          "donationsDone": 0,
          "pickupsDone": 0,
          "dropsDone": 0,
          "dropsIds": [],
          "donationIds": [],
          "pickupIds": [],
          "spotsDone": 0,
          "spotIds": []
        });
        String userId = newUserRef.id;
        String usernameFinal = await DatabaseService(uid: userId)
            .ensureUniqueUsername(generateUsername(_userMail, c1.text));
        QuerySnapshot querySnapshot =
            await users.where('email', isEqualTo: _userMail).get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update the first document found with the provided email
          await querySnapshot.docs.first.reference.update(
              {'userName': usernameFinal, 'updatedAt': Timestamp.now()});
        }

        // Show a message indicating that a new document has been added
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New user document added')),
        );
      }
    } catch (error) {
      // Handle error
      print('Error updating profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Container(
          color: Color(0xFF024EA6), // Set your desired app bar color here
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
            child: Container(
              height: 89,
              decoration: const BoxDecoration(color: Color(0xFF024EA6)),
              child: Row(
                children: [
                  ProfileImageWidget(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_fullName",
                          style: TextStyle(
                              // shadows: <Shadow>[
                              //   Shadow(
                              //     offset: Offset(0, 3),
                              //     blurRadius: 6,
                              //     color: Color(0xFF000000),
                              //   ),
                              // ],
                              fontSize: 20,
                              color: Color.fromARGB(199, 255, 255, 255),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$_UserName",
                          style: TextStyle(
                            // shadows: <Shadow>[
                            //   Shadow(
                            //     offset: Offset(0, 3),
                            //     blurRadius: 6,
                            //     color: Color(0xFF000000),
                            //   ),
                            // ],
                            color: Color.fromARGB(199, 255, 255, 255),
                            fontFamily: "Inter",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AppBar(
          title: const Text(
            "Edit Profile",
            style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFCAE3FF),
            elevation: 4,
            shadowColor: const Color(0xFF000000),
            child: TextFormField(
              initialValue:
                  _userMail ?? "", // Set initial value if userEmail is present
              enabled: _userMail ==
                  "", // Make it non-editable if userEmail is present
              // controller: c6,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFCAE3FF)),
                ),
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFCAE3FF),
            elevation: 4,
            shadowColor: const Color(0xFF000000),
            child: TextFormField(
              controller: c1,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAE3FF))),
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFCAE3FF),
            elevation: 4,
            shadowColor: const Color(0xFF000000),
            child: TextFormField(
              controller: c2,
              // initialValue:
              //     _phoneNo ?? "", // Set initial value if userEmail is present
              enabled: _phoneNo == "",
              maxLength: 10,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAE3FF))),
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFCAE3FF),
            elevation: 4,
            shadowColor: const Color(0xFF000000),
            child: TextFormField(
              controller: c3,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAE3FF))),
                labelText: "Age",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFCAE3FF),
            elevation: 4,
            shadowColor: const Color(0xFF000000),
            child: TextFormField(
              controller: c4,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAE3FF))),
                labelText: "Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: const Color(0xFFCAE3FF),
            elevation: 4,
            shadowColor: const Color(0xFF000000),
            child: GestureDetector(
              onTap: () {
                // Show date picker dialog
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((selectedDate) {
                  // Handle the selected date
                  if (selectedDate != null) {
                    // Format the selected date to display only the date
                    String formattedDate =
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                    // Update the text field's value with the formatted date
                    c5.text = formattedDate;
                  }
                });
              },
              child: TextFormField(
                controller: c5,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAE3FF)),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Show date picker dialog when the icon is pressed
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((selectedDate) {
                        // Handle the selected date
                        if (selectedDate != null) {
                          // Format the selected date to display only the date
                          String formattedDate =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          // Update the text field's value with the formatted date
                          c5.text = formattedDate;
                        }
                      });
                    },
                    icon: const ImageIcon(
                      AssetImage("assets/Icons/calendar.png"),
                    ),
                  ),
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    borderSide: const BorderSide(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: _updateProfile, //() {
          // Navigator.pop(context);

          // },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(2, 78, 166, 1),
            ),
            width: 260,
            height: 55,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Update Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ]),
    ));
  }
}
