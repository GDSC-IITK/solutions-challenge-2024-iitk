import 'package:flutter/material.dart';

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
        title: Text("Profile Page"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(),
              title: Text("Name"),
              subtitle: Text("@name"),
              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              elevation: 4,
              shadowColor: Color(0xFF000000),
              child: ListTile(
                tileColor: Color(0xFFCAE3FF),
                leading: const ImageIcon(
                  AssetImage(
                    "assets/Icons/Donation.png",
                  ),
                  color: Color(0xFF024EA6),
                ),
                title: Text("Name"),
                trailing: IconButton(
                    onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
