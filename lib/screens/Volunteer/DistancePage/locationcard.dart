import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gdsc/screens/Maps/maps.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class locationcard extends StatefulWidget {
  const locationcard(
      {super.key,
      required this.heading,
      required this.address,
      required this.coordinates,
      required this.donationId,
      required this.pickupId});

  final String heading;
  final String address;
  final GeoPoint coordinates;
  final String donationId;
  final String pickupId;
  @override
  State<locationcard> createState() => _locationcardState();
}

class _locationcardState extends State<locationcard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 2,
        shadowColor: Colors.grey,
        child: ExpansionTile(
          expandedAlignment: Alignment.bottomRight,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.black,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          title: Text(
            widget.heading ?? "",
            style: TextStyle(fontSize: 13),
          ),
          subtitle: Text(
            "${widget.address} km away from you" ?? "",
            style: TextStyle(fontSize: 10, color: Color(0xFF048228)),
          ),
          leading: const ImageIcon(
            AssetImage("assets/Icons/locationred.png"),
            color: Colors.red,
            size: 37,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFF048228))),
                  onPressed: () {
                    nextScreen(
                        context,
                        Maps(
                            donationId: widget.donationId,
                            pickupId: widget.pickupId,
                            location: widget.coordinates));
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
