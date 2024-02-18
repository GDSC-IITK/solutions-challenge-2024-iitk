import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screens/Donate/donate_3.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';

class OrganisationDonateContainer extends StatefulWidget {
  const OrganisationDonateContainer({Key? key}) : super(key: key);

  @override
  State<OrganisationDonateContainer> createState() =>
      _OrganisationDonateContainerState();
}

class _OrganisationDonateContainerState
    extends State<OrganisationDonateContainer> {
  String _selectedValue = 'Option 1';
  TextEditingController itemname = TextEditingController();
  TextEditingController itemndesc = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController remarks = TextEditingController();
  TextEditingController organization = TextEditingController();

  List<String> _options = [
    'in Kilograms(kg)',
    'in Liters(l)',
    'in Pounds(lb)',
    'in Ounces(oz)',
    'in Pieces'
  ];
  @override
  void initState() {
    super.initState();
    _selectedValue = _options.first;
  }

  Future<String> getLocationFromGeoPoint(GeoPoint geoPoint) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geoPoint.latitude,
        geoPoint.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String street = placemark.street ?? 'N/A';
        String city = placemark.locality ?? 'N/A';
        String state = placemark.administrativeArea ?? 'N/A';
        String country = placemark.country ?? 'N/A';

        // Concatenate the address components
        String fullAddress = '$street, $city, $state, $country';

        return fullAddress;
      } else {
        return 'N/A';
      }
    } catch (e) {
      print('Error getting location: $e');
      return 'N/A';
    }
  }

  Widget build(BuildContext context) {
    final Width = MediaQuery.of(context).size.width;

    return Container(
        child: Column(children: [
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Image.asset(
              'assets/images/organisation_donate_page_picture.png.png')),
      const SizedBox(
        height: 10,
      ),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Organisation",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: organization,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            )
          ])),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Item Name",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: itemname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            )
          ])),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Item Description",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: itemndesc,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            )
          ])),
      Center(
          child: Container(
              child: Row(children: <Widget>[
        Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity",
                          style: GoogleFonts.inter(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: quantity,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ]))),
        Container(
            alignment: Alignment.centerLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 25,
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
                  child: DropdownButton<String>(
                      value: _selectedValue,
                      items: _options.map((value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value!;
                        });
                      }),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ]))
      ]))),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Address",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: location,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
          ])),
      Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () async {
            setState(() {
              // Set a loading indicator while fetching the location
              location.text =
                  "Fetching location..."; // or any other loading message
            });
            GeoPoint? currentLocation = await getCurrentLocation();
            if (currentLocation != null) {
              location.text = await getLocationFromGeoPoint(currentLocation);
            } else {
              setState(() {
                // Handle the case where getCurrentLocation() returns null
                // For example, display an error message or provide a default location
                location.text = "Unable to fetch location";
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Continue with current location', // This will display either the loading message or the fetched location
              style: GoogleFonts.inter(
                color: Color.fromRGBO(102, 102, 102, 0.7),
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Comments",
                style: GoogleFonts.inter(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: remarks,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                )),
          ])),
      InkWell(
        onTap: () {
          if (itemname.text != '' &&
              quantity.text != '' &&
              location.text != '' &&
              remarks.text != '' &&
              organization.text != '' &&
              itemndesc.text != '') {
            // Check if organization is not required or is not null when donating as an organization
            nextScreen(
              context,
              Donate_3(
                  imageUrl: '',
                  type: 'organization',
                  weightMetric: _selectedValue,
                  itemname: itemname.text!,
                  quantity: quantity.text!,
                  location: location.text!,
                  remarks: remarks.text!,
                  organization: organization.text!,
                  itemdesc: itemndesc.text!),
            );
          } else {
            // Show a snackbar or any other feedback to indicate missing fields
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please fill in all the required fields.'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(2, 78, 166, 1),
              ),
              width: Width / 1.1,
              height: 50,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Inter"),
                ),
              ),
            ),
          ),
        ),
      )
    ]));
  }
}
