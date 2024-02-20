import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/spotHistory.dart';
import 'package:gdsc/services/providers.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:provider/provider.dart';

class spotactivity extends StatefulWidget {
  const spotactivity({super.key});

  @override
  State<spotactivity> createState() => _spotactivityState();
}

class _spotactivityState extends State<spotactivity> {
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
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              height: 128,
              decoration: const BoxDecoration(color: Color(0xFF024EA6)),
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
                              .toJson()['fullName']
                              .toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Inter",
                              color: Color.fromARGB(199, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${context.read<Providers>().user_data.toJson()['userName'].toString()}",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color.fromARGB(199, 255, 255, 255),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ),
          ),
          AppBar(
            title: Text(
              "Spot Details",
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
                title: Text(
                  "Number of Spot Activity : ${context.read<Providers>().user_data.toJson()['spotIds'].length.toString()}",
                  style: const TextStyle(
                    fontFamily: "Inter",
                  ),
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
                title: const Text(
                  "Spot History",
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      nextScreen(context, spothistory());
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
