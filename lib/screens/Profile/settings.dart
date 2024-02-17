import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/updateProfile.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/function/getuser.dart';


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
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: 128,
              decoration: const BoxDecoration(color: Color(0xFFCAE3FF)),
              child:  Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 44,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$_fullName",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$_UserName",
                          style: TextStyle(
                            fontFamily: "Inter",
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: Color(0xFF000000),
              child: ListTile(
                tileColor: Color(0xFFCAE3FF),
                title: Text(
                  "Notification Preferences",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: Color(0xFF000000),
              child: ListTile(
                tileColor: Color(0xFFCAE3FF),
                title: Text(
                  "Password",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: Color(0xFF000000),
              child: ListTile(
                tileColor: Color(0xFFCAE3FF),
                title: Text(
                  "Device Permissions",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
