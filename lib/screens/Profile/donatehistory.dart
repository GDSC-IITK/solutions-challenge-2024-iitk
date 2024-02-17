import 'package:flutter/material.dart';

class donatehistory extends StatefulWidget {
  const donatehistory({super.key});

  @override
  State<donatehistory> createState() => _donatehistoryState();
}

class _donatehistoryState extends State<donatehistory> {
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
            title: const Text(
              "Donation History",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13.0, left: 15, right: 15),
            child: Container(
              height: 115,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(7)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Organisation name",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF666666)),
                      ),
                      Text(
                        "Quantity",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF666666)),
                      ),
                      Text(
                        "Location",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF666666)),
                      ),
                      Text(
                        "Remarks",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
