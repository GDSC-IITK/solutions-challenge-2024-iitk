import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/updateProfile.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Profilemain extends StatefulWidget {
  const Profilemain({super.key});

  @override
  State<Profilemain> createState() => _ProfilemainState();
}

class _ProfilemainState extends State<Profilemain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFCAE3FF),
        title: const Text("Profile Page"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: 128,
              decoration: const BoxDecoration(color: Color(0xFFCAE3FF)),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 44,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@name",
                          style: TextStyle(
                            fontFamily: "Inter",
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                  ),
                  IconButton(
                    onPressed: () {
                      nextScreen(context, updateProfile());
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF024EA6),
                    ),
                  ),
                ],
              ),
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
              child: ListTile(
                tileColor: const Color(0xFFCAE3FF),
                leading: const ImageIcon(
                  AssetImage(
                    "assets/Icons/Donation.png",
                  ),
                  color: Color(0xFF024EA6),
                ),
                title: const Text(
                  "Name",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {},
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
                leading: const ImageIcon(
                  AssetImage(
                    "assets/Icons/location.png",
                  ),
                  color: Color(0xFF024EA6),
                ),
                title: const Text(
                  "Location",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {},
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
                trailing: IconButton(
                    onPressed: () {},
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
                trailing: IconButton(
                    onPressed: () {},
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
                                style: TextStyle(fontFamily: "Inter"),
                              )),
                              content: SizedBox(
                                height: 125,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 40,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              border: Border.symmetric(
                                                  horizontal: BorderSide(
                                                      color: Colors.grey))),
                                          child: const Center(
                                            child: Text(
                                              "Current Device",
                                              style: TextStyle(
                                                  fontFamily: "Inter"),
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
                                                  horizontal: BorderSide(
                                                      color: Colors.grey))),
                                          child: const Center(
                                            child: Text(
                                              "All Devices",
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

                                      // Text(
                                      //   "Are you sure you want to log out?",
                                      //   style: TextStyle(fontFamily: "Inter"),
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: OutlinedButton(
                                      //           style: TextButton.styleFrom(),
                                      //           onPressed: () {
                                      //             Navigator.pop(context);
                                      //           },
                                      //           child: const Text(
                                      //             "Cancel",
                                      //             style: TextStyle(
                                      //                 color: Colors.black,
                                      //                 fontFamily: "Inter",
                                      //                 fontSize: 12),
                                      //           )),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: OutlinedButton(
                                      //           style: TextButton.styleFrom(
                                      //               backgroundColor: Colors.red,
                                      //               side: const BorderSide(
                                      //                   color: Colors.red)),
                                      //           onPressed: () {},
                                      //           child: const Text(
                                      //             "Yes, Log Out",
                                      //             style: TextStyle(
                                      //                 color: Colors.white,
                                      //                 fontFamily: "Inter",
                                      //                 fontSize: 12),
                                      //           )),
                                      //     ),
                                      //   ],
                                      // )
                                    ]),
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}