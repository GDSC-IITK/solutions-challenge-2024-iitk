import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/donationactivity.dart';
import 'package:gdsc/screens/Profile/dropActivity.dart';
import 'package:gdsc/screens/Profile/settings.dart';
import 'package:gdsc/screens/Profile/spotSomeoneActivity.dart';
import 'package:gdsc/screens/Profile/updateProfile.dart';
import 'package:gdsc/screens/Profile/volunteeractivity.dart';
import 'package:gdsc/screens/vision_page.dart';
import 'package:gdsc/services/providers.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:provider/provider.dart';
import 'package:gdsc/data_models/user.dart' as user_data;

class Profilemain extends StatefulWidget {
  const Profilemain({Key? key}) : super(key: key);

  @override
  State<Profilemain> createState() => _ProfilemainState();
}

class _ProfilemainState extends State<Profilemain> {
  String _userMail = "";
  String _UserName = "";
  String _fullName = "";
  user_data.User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    print("provider");
    print(context.read<Providers>().user_data.toJson());
    print(context
        .read<Providers>()
        .user_data
        .toJson()['profileImageLink']
        .toString());
  }

  // Function to load user's name from Firebase
  void _loadUserName() async {
    setState(() {
      _user = context.read<Providers>().user_data.toJson() as user_data.User;
    });
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userMail = user.email ?? "";
      });
      Map<String, String> userData = await fetchData(_userMail);
      setState(() {
        _UserName = userData['userName'] ?? '';
        _fullName = userData['fullName'] ?? '';
      });
    }
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Pop out all screens until reaching the root page
      Navigator.of(context).popUntil((route) => route.isFirst);
      // Navigate to the login page or any other appropriate screen after logout
      nextScreenReplace(context, VisionPage());
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  void _showFeedbackDialog(BuildContext context) {
    String name = '';
    String feedback = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Provide Feedback'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Your Name'),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Feedback'),
                  onChanged: (value) {
                    setState(() {
                      feedback = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Submit feedback here
                print("here");
                print(name);
                print(feedback);
                _submitFeedback(name, feedback);
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitFeedback(String name, String feedback) async {
    // Save feedback to Firestore collection named "Feedback"
    User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('Feedback').add({
      'name': name,
      'feedback': feedback,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      'userId': user!.uid
    }).then((value) {
      // Feedback submitted successfully
      // You can add any additional handling here, such as showing a confirmation message
      print('Feedback submitted successfully');
    }).catchError((error) {
      // Error handling if submission fails
      print('Failed to submit feedback: $error');
    });
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: const Color(0xFFCAE3FF),
      //   title: const Text("Profile Page"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 128,
              color: Color(0xFF024EA6), // Set your desired app bar color here
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
                                      .toJson()['fullName'] !=
                                  null
                              ? "${context.read<Providers>().user_data.toJson()['fullName'].toString()}"
                              : "", // Empty string if full name is null
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Inter",
                            color: Color.fromARGB(199, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context
                                      .read<Providers>()
                                      .user_data
                                      .toJson()['userName'] !=
                                  null
                              ? "@${context.read<Providers>().user_data.toJson()['userName'].toString()}"
                              : "", // Empty string if username is null
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color.fromARGB(199, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    nextScreen(context, donationactivity());
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: const ImageIcon(
                      AssetImage(
                        "assets/Icons/Donation.png",
                      ),
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "Your Donations",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    nextScreen(context, volunteeractivity());
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: const ImageIcon(
                      AssetImage(
                        "assets/Icons/Vactivity.png",
                      ),
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "Pickup Activity",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    nextScreen(context, dropactivity());
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: const ImageIcon(
                      AssetImage(
                        "assets/Icons/Vactivity.png",
                      ),
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "Drop Activity",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    nextScreen(context, spotactivity());
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: const ImageIcon(
                      AssetImage(
                        "assets/Icons/Vactivity.png",
                      ),
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "Spot Someone Activity",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    nextScreen(context, settings());
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: const ImageIcon(
                      AssetImage(
                        "assets/Icons/settings.png",
                      ),
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "Settings",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    _showFeedbackDialog(context);
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: Icon(
                      Icons.feedback,
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "Provide Feedback",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text(
                              'About',
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: SizedBox(
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: Center(
                                    child: FutureBuilder<String>(
                                      future: getAppVersion(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return Text(
                                            'App Version: ${snapshot.data} (Alpha Testing)',
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Terms and Conditions",
                                        style: TextStyle(fontFamily: "Inter"),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Privacy Policy",
                                        style: TextStyle(fontFamily: "Inter"),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Developers:\n\nSahil\nSaugat\nRushab\nKushagra\nSanskar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "Inter"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    tileColor: const Color(0xFFCAE3FF),
                    leading: const ImageIcon(
                      AssetImage(
                        "assets/Icons/about.png",
                      ),
                      color: Color(0xFF024EA6),
                    ),
                    title: const Text(
                      "About",
                      style: TextStyle(
                        fontFamily: "Inter",
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                shadowColor: const Color(0xFF000000),
                child: ListTile(
                  tileColor: const Color(0xFFCAE3FF),
                  leading: const ImageIcon(
                    AssetImage(
                      "assets/Icons/logout.png",
                    ),
                    color: Color(0xFF024EA6),
                  ),
                  title: const Text(
                    "Log out",
                    style: TextStyle(
                      fontFamily: "Inter",
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Center(
                                    child: Text(
                                  'Log out from?',
                                  style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.bold),
                                )),
                                content: SizedBox(
                                  height: 120,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Are you sure you want to log out?"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _handleLogout();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                border: Border.symmetric(
                                                    horizontal: BorderSide(
                                                        color: Colors.grey))),
                                            child: const Center(
                                              child: Text(
                                                "Log Out",
                                                style: TextStyle(
                                                    fontFamily: "Inter"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                                border: Border.symmetric(
                                                    horizontal: BorderSide(
                                                        color: Colors.grey))),
                                            child: const Center(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    color: Color(0xFF666666)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            });
                      },
                      icon: const Icon(Icons.arrow_forward_ios)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Developed by GDSC IITK",
                style: TextStyle(
                  fontFamily: "Inter",
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
