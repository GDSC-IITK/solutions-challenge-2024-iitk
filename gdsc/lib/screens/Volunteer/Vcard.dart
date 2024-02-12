import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/Page1.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class Vcard extends StatelessWidget {
  const Vcard(
      {super.key,
      required this.item,
      required this.quantity,
      required this.location});
  final String item;
  final String quantity;
  final String location;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25.0, right: 25, top: 10, bottom: 10),
        child: Material(
          elevation: 3,
          shadowColor: Colors.grey,
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            onTap: () {
              nextScreen(
                  context,
                  const Page1(
                    itemname: 'Carrot',
                    quantity: '10 kg',
                    location: 'location',
                    remarks: 'remarks',
                    organization: 'McD',
                  ));
            },
            leading: Image.asset(
              "assets/images/home.jpeg",
              height: 80,
              width: 80,
            ),
            title: Text(
              item,
              style: const TextStyle(fontSize: 20),
            ),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quantity: $quantity",
                  style: TextStyle(color: Colors.grey),
                ),
                Text("Location: $location",
                    style: TextStyle(color: Colors.grey)),
                const Text(
                  "300 mts away",
                  style: TextStyle(color: Color.fromRGBO(2, 78, 166, 1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
