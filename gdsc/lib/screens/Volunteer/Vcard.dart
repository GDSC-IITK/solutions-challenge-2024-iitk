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
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
          title: Text(item),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quantity),
              Text(location),
            ],
          ),
        ),
      ),
    );
  }
}
