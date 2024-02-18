import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/upatePassword.dart';
import 'package:gdsc/screens/Profile/updateProfile.dart';
import 'package:gdsc/services/providers.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  String _userMail = "";
  String _UserName = "";
  String _fullName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _launchNotificationSettings() async {
    const url = 'app-settings:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _loadUserName() async {
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

  Future<void> changePassword(String newPassword) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      print('Password changed successfully');
    } else {
      print('No user signed in.');
      // Handle the scenario when no user is signed in
    }
  } catch (error) {
    print('Error changing password: $error');
    // Handle any errors that occur during password change
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Color(0xFF024EA6), // Set your desired app bar color here
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
              child: Container(
                height: 128,
                // decoration: const BoxDecoration(color: Color(0xFFCAE3FF)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 44,
                        backgroundImage:
                          NetworkImage(context.read<Providers>().user_data.toJson()['profileImageLink'].toString()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$_fullName",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Inter",
                                color: Color.fromARGB(199, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "$_UserName",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Color.fromARGB(199, 255, 255, 255),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 150,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: const Color(0xFF000000),
              child: ListTile(
                tileColor: const Color(0xFFCAE3FF),
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      nextScreen(context, updateProfile());
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
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
                title: const Text(
                  "Notification Preferences",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.notification);
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: Color(0xFF000000),
              child: ListTile(
                tileColor: Color(0xFFCAE3FF),
                title: Text(
                  "Update Password",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      nextScreen(context, UpdatePasswordScreen());
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: Color(0xFF000000),
              child: ListTile(
                tileColor: Color(0xFFCAE3FF),
                title: Text(
                  "Location Permissions",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.location);
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
