import 'package:flutter/material.dart';
import 'package:gdsc/screens/Volunteer/Page1.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:intl/intl.dart';

class Vcard extends StatelessWidget {
  Vcard(
      {super.key,
      required this.item,
      this.distance = 0,
      required this.quantity,
      required this.id,
      required this.extraData,
      required this.location});
  final String item;
  final int quantity;
  final String location;
  double distance;
  final Map<dynamic, dynamic> extraData;
  final String id;

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = extraData['createdAt'].toDate();
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(createdAt);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    String timeAgo =
        '${hours > 0 ? '$hours hours, ' : ''}${minutes > 0 ? '$minutes minutes' : 'just now'} ago';

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
                Page1(
                  itemname: item,
                  quantity: quantity.toString(),
                  location: location,
                  remarks: '',
                  extraData: extraData,
                  id: id,
                ),
              );
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
                Text(
                  "Location: $location",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Posted $timeAgo',
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize:
                          12), // Adjust the opacity and font size as needed
                ),
                Text(
                  '${distance.toStringAsFixed(2)} kms away',
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
