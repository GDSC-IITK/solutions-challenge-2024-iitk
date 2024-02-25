import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/generateUserName.dart';
import 'package:gdsc/palette.dart';
import 'package:gdsc/screens/Maps/maps.dart';
import 'package:gdsc/screens/Maps/spotsomeone.dart';
import 'package:gdsc/screens/Profile/profilemain.dart';
import 'package:gdsc/screens/Donate/donate_page.dart';
import 'package:gdsc/screens/Profile/updateProfile.dart';
import 'package:gdsc/screens/Donate/donate_page.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'package:gdsc/screens/home.dart';
import 'package:gdsc/screens/home/post_scroll_page.dart';
import 'package:gdsc/screens/home/title_page.dart';
import 'package:gdsc/screens/home/yo.dart';
import 'package:gdsc/screens/notification_page.dart';
import 'package:gdsc/services/database_services.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/services/providers.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:gdsc/screens/loader.dart';
import 'package:gdsc/data_models/user.dart' as User_1;
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int current_index = 0;
  final List<Widget> pages = [
    HomePagenew(),
    DonatePage(),
    volunteer(),
    Profilemain()
  ];
  bool _isLoading = false; // Add a boolean variable to track loading state
  bool _isExpanded = true;

  void OnTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  List<Widget> getDialogContent() {
    print(_isExpanded);
    print("getDialogContent");
  if (_isExpanded) {
    return [
      Text(
        'Before proceeding, we need to inform you about our app\'s usage of location data. FeedHarmony collects location data to enable features such as food donation pickups, volunteer opportunities, and real-time notifications, even when the app is closed or not in use. This data is essential for providing you with the best experience and ensuring efficient delivery of surplus food to those in need.',
      ),
      SizedBox(height: 10),
      Text(
        'By continuing to use our app, you consent to the collection and use of your location data for these purposes. Rest assured that we prioritize the security and privacy of your data, and it will not be shared with any third parties. If you have any concerns or questions about how we handle your location data, please refer to our privacy policy or contact our support team for assistance.',
      ),
      SizedBox(height: 10),
      Text(
        'Thank you for your understanding and support in our mission to fight food waste and hunger.',
      ),
    ];
  } else {
    return [];
  }
}


  String _userMail = "";
  String _UserName = "";
  String _fullName = "";

  Future<void> checkIfEmailOrPhoneNumberExists(
      String email, String phoneNumber) async {
    final QuerySnapshot emailQuery = await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get();

    final QuerySnapshot phoneNumberQuery = await FirebaseFirestore.instance
        .collection("Users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();
    setState(() {
      _isLoading = true;
    });
    GeoPoint? curr;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Usage'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'This app collects location data to enable certain features, such as providing nearby services and personalized content.'),
              SizedBox(height: 10),
              Text(
                  'By granting permission, you allow the app to collect location data even when the app is closed or not in use.'),
              SizedBox(height: 10),
              Text('Do you wish to proceed and grant location access?'),
              SizedBox(height: 10),
          //     GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       _isExpanded = !_isExpanded;
          //       print(_isExpanded);
          //     });
          //   },
          //   child: Text(
          //     _isExpanded ? 'Collapse' : 'Expand More',
          //     style: TextStyle(
          //       color: Colors.blue,
          //       decoration: TextDecoration.underline,
          //     ),
          //   ),
          // ),
          // ...getDialogContent(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Request permission
                Navigator.pop(context);
                curr = await getCurrentLocation(context);
              },
              child: Text('Grant Permission'),
            ),
            TextButton(
              onPressed: () async {
                // Request permission
                exit(0);
              },
              child: Text('Deny'),
            ),
          ],
        );
      },
    );
    print("Current Location");
    curr = await getCurrentLocation(context);

    print(curr?.latitude);
    print(curr?.latitude);
    context.read<Providers>().setCurrentLocation(curr);
    if (emailQuery.docs.isEmpty == false && emailQuery.docs.first.id.isNotEmpty)
      await context
          .read<Providers>()
          .setUserFromFirestoreId(emailQuery.docs.first.id);
    else if (phoneNumberQuery.docs.isEmpty == false &&
        phoneNumberQuery.docs.first.id.isNotEmpty)
      await context
          .read<Providers>()
          .setUserFromFirestoreId(phoneNumberQuery.docs.first.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fetching All data...'),
      ),
    );
    setState(() {
      _isLoading = false;
    });

    if (emailQuery.docs.isEmpty && phoneNumberQuery.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please update your profile first')),
      );
      // Neither email nor phone number exists, redirect user to edit profile page
      nextScreenReplace(context, updateProfile());
    }
    print(emailQuery);
    print(phoneNumberQuery);
    print("check");
    if (emailQuery.docs.isNotEmpty) {
      final name = emailQuery.docs.isNotEmpty &&
              (emailQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('fullName')
          ? emailQuery.docs.first.get('fullName')
          : "";
      final userName = emailQuery.docs.isNotEmpty &&
              (emailQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('userName')
          ? emailQuery.docs.first.get('userName')
          : "";
      final phoneNumber = emailQuery.docs.isNotEmpty &&
              (emailQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('phoneNumber')
          ? emailQuery.docs.first.get('phoneNumber')
          : "";
      final dob = emailQuery.docs.isNotEmpty &&
              (emailQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('dateOfBirth')
          ? emailQuery.docs.first.get('dateOfBirth')
          : "";
      final currentLocation = emailQuery.docs.isNotEmpty &&
              (emailQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('currentLocation')
          ? emailQuery.docs.first.get('currentLocation')
          : "";
      final age = emailQuery.docs.isNotEmpty &&
              (emailQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('age')
          ? emailQuery.docs.first.get('age')
          : "";

      print(emailQuery.docs.first.id);
      print("email query");

      if (userName == "") {
        print("updating username");
        String usernameFinal =
            await DatabaseService(uid: emailQuery.docs.first.id)
                .ensureUniqueUsername(generateUsername(_userMail, _fullName));

        print(usernameFinal);

        // Update the first document found with the provided email
        await emailQuery.docs.first.reference
            .update({'userName': usernameFinal, 'updatedAt': Timestamp.now()});
      }

      if (name.isEmpty ||
          userName.isEmpty ||
          phoneNumber.isEmpty ||
          dob.isEmpty ||
          currentLocation.isEmpty ||
          age.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please update your profile first')),
        );
        // Neither email nor phone number exists, redirect user to edit profile page
        nextScreen(context, updateProfile());
      }
    } else if (phoneNumberQuery.docs.isNotEmpty) {
      final name = phoneNumberQuery.docs.isNotEmpty &&
              (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('fullName')
          ? phoneNumberQuery.docs.first.get('fullName')
          : "";
      final userName = phoneNumberQuery.docs.isNotEmpty &&
              (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('userName')
          ? phoneNumberQuery.docs.first.get('userName')
          : "";
      final email = phoneNumberQuery.docs.isNotEmpty &&
              (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('email')
          ? phoneNumberQuery.docs.first.get('email')
          : "";
      final dob = phoneNumberQuery.docs.isNotEmpty &&
              (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('dateOfBirth')
          ? phoneNumberQuery.docs.first.get('dateOfBirth')
          : "";
      final currentLocation = phoneNumberQuery.docs.isNotEmpty &&
              (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('currentLocation')
          ? phoneNumberQuery.docs.first.get('currentLocation')
          : "";
      final age = phoneNumberQuery.docs.isNotEmpty &&
              (phoneNumberQuery.docs.first.data() as Map<String, dynamic>)
                  .containsKey('age')
          ? phoneNumberQuery.docs.first.get('age')
          : "";

      if (name.isEmpty ||
          userName.isEmpty ||
          email.isEmpty ||
          dob.isEmpty ||
          currentLocation.isEmpty ||
          age.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please update your profile first')),
        );
        // Neither email nor phone number exists, redirect user to edit profile page
        nextScreen(context, updateProfile());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Function to load user's name from Firebase
  void _loadUserName() async {
    setState(() {
      _isLoading = true;
    });
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    print("load user name");
    if (user != null) {
      setState(() {
        _userMail = user.email ?? "";
      });
      Map<String, String> userData = await fetchData(_userMail);
      setState(() {
        _UserName = userData['userName'] ?? '';
        _fullName = userData['fullName'] ?? '';
      });
      print("here home page");
      print(user.phoneNumber);
      await checkIfEmailOrPhoneNumberExists(
          _userMail ?? "", user.phoneNumber ?? "");

      print(user);
      print(_userMail);
      print(_UserName);
      print(_fullName);
      setState(() {
        _isLoading = false;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        User? refreshedUser = FirebaseAuth.instance.currentUser;
        if (refreshedUser != null) {
          print('User is signed in after delay: ${refreshedUser.uid}');
          _loadUserName();
        } else {
          print('User is still not signed in after delay');
        }
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading ? null : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(2, 78, 166, 1),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
              'Welcome, ${_UserName.isNotEmpty ? '@$_UserName' : (_fullName.isNotEmpty ? _fullName : _userMail)}',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(255, 253, 251, 1),
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              )),
          Text('Your step to eradicate hunger',
              style: GoogleFonts.inter(
                color: Color.fromRGBO(255, 253, 251, 1),
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              )),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Column(
                          children: [
                            Text(
                              "Spot Someone in Need",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Inter"),
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Help us reach those in need! If you come across someone who could benefit from our support, you can pin their location on the map.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Inter"),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                nextScreenReplace(context, spotSomeone());
                              },
                              child: Text(
                                "Go Ahead",
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22),
                              ),
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(160, 59)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color(0xFF024EA6))),
                            ),
                          ],
                        ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ));
            },
            icon: Icon(Icons.add),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              nextScreen(context, NotificationScreen());
            },
            icon: Icon(Icons.notifications),
            color: Colors.white,
          ),
        ],
      ),
        body: _isLoading
          ? LoaderScreen()
          : pages.elementAt(current_index),
      bottomNavigationBar: _isLoading ? null : Container(
        color: Color.fromRGBO(2, 78, 166, 1),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 26,
            backgroundColor: Color.fromRGBO(2, 78, 166, 1),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            currentIndex: current_index,
            selectedFontSize: 20,
            unselectedFontSize: 14,
            onTap: (index) {
              OnTapped(index);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/Icons/Donation.png")),
                  label: "Donate"),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage("assets/Icons/Vactivity.png")),
                  label: "Volunteer"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
      ),
    );
  }
}
