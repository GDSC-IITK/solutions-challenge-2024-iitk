import 'package:flutter/material.dart';

class updateProfile extends StatefulWidget {
  const updateProfile({super.key});

  @override
  State<updateProfile> createState() => _updateProfileState();
}

class _updateProfileState extends State<updateProfile> {
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  TextEditingController c4 = TextEditingController();
  TextEditingController c5 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Container(
            height: 89,
            decoration: const BoxDecoration(color: Color(0xFF024EA6)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0xFF000000),
                            spreadRadius: 0.8)
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 44,
                    ),
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
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Color(0xFF000000),
                              ),
                            ],
                            fontSize: 20,
                            color: Color(0xFFFFFFFF),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "@name",
                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              color: Color(0xFF000000),
                            ),
                          ],
                          color: Color(0xFFD7D7D7),
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
              controller: c1,
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
                labelText: "Email ID",
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
            child: TextFormField(
              controller: c5,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCAE3FF))),
                suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const ImageIcon(
                        AssetImage("assets/Icons/calendar.png"))),
                labelText: "Date of Birth",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 160,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
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
