import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/volunteerhistory.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class volunteeractivity extends StatefulWidget {
  const volunteeractivity({super.key});

  @override
  State<volunteeractivity> createState() => _volunteeractivityState();
}

class _volunteeractivityState extends State<volunteeractivity> {
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
              child: const Row(
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
                  SizedBox(
                    width: 150,
                  ),
                ],
              ),
            ),
          ),
          AppBar(
            title: Text(
              "Volunteering Details",
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
                  "Hours Contributed",
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
                title: const Text(
                  "Volunteering History",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      nextScreen(context, volunteerhistory());
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
                  "Volunteering Goals",
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
                  "Badges Earned",
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
