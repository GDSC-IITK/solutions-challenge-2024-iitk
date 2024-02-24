import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gdsc/screens/Volunteer/DistancePage/locationcard.dart';
import 'package:gdsc/screens/Volunteer/Vcard.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:gdsc/services/helper/getLocationfromGeopoint.dart';
import 'package:gdsc/services/providers.dart';
import 'package:provider/provider.dart';

class Location extends StatefulWidget {
  const Location({super.key, required this.all, required this.donationId, required this.pickupId});
  final Map<String, dynamic> all;
  final String donationId;
  final String pickupId;
  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location>
    with SingleTickerProviderStateMixin {
  GeoPoint _currentLoc = GeoPoint(0, 0);
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController!.addListener(() {
      setState(() {});
    });
    loadData();
  }

  loadData() {
    getCurrentLocation(context).then((value) => {
          setState(() {
            _currentLoc = value!;
          })
        });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  TabController? _tabController;
  // Widget _tab(int index) {
  //   double Width = MediaQuery.of(context).size.width; // Gives the width

  //   List<Widget> VCard = [locationcard(), locationcard(), locationcard()];

  //   return SingleChildScrollView(
  //     child: VCard[index],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        AppBar(
            title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Recommended Locations\n',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                    fontFamily: "Inter"),
              ),
              TextSpan(
                text: 'Drop locations around your surroundings',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontFamily: "Inter"),
              ),
            ],
          ),
        )),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: widget.all.keys.map((key) {
                var data = widget.all[key];
                return locationcard(
                  heading: data['address'],
                  address: calculateDistanceNew(
                    data['location'].latitude,
                    data['location'].longitude,
                    context.read<Providers>().current_loc_data!.latitude,
                    context.read<Providers>().current_loc_data!.longitude,
                  ).toString() + ' km away from you',
                  coordinates: data['location'],
                  donationId: widget.donationId ?? '',
                  pickupId: widget.pickupId ?? '',
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'All Locations\n',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                        fontFamily: "Inter"),
                  ),
                  TextSpan(
                    text: 'Includes all drop points',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                        fontSize: 14,
                        fontFamily: "Inter"),
                  ),
                ],
              ),
            ),
            // bottom: TabBar(
            //   controller: _tabController,
            //   tabs: [
            //     Container(
            //       height: 30,
            //       width: MediaQuery.of(context).size.width / 4,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         border: Border.all(
            //           color: Color.fromRGBO(2, 78, 166, 1),
            //         ),
            //         color: _tabController!.index == 0
            //             ? Color.fromRGBO(2, 78, 166, 1)
            //             : Colors.white,
            //       ),
            //       child: Center(
            //         child: Text(
            //           "0-2 km",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: _tabController!.index == 0
            //                 ? Colors.white
            //                 : Color.fromRGBO(2, 78, 166, 1),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: 30,
            //       width: MediaQuery.of(context).size.width / 4,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         border: Border.all(
            //           color: Color.fromRGBO(2, 78, 166, 1),
            //         ),
            //         color: _tabController!.index == 1
            //             ? Color.fromRGBO(2, 78, 166, 1)
            //             : Colors.white,
            //       ),
            //       child: Center(
            //         child: Text(
            //           "2-5 km",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: _tabController!.index == 1
            //                 ? Colors.white
            //                 : Color.fromRGBO(2, 78, 166, 1),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: 30,
            //       width: MediaQuery.of(context).size.width / 4,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         border: Border.all(
            //           color: Color.fromRGBO(2, 78, 166, 1),
            //         ),
            //         color: _tabController!.index == 2
            //             ? Color.fromRGBO(2, 78, 166, 1)
            //             : Colors.white,
            //       ),
            //       child: Center(
            //         child: Text(
            //           "Custom",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: _tabController!.index == 2
            //                 ? Colors.white
            //                 : Color.fromRGBO(2, 78, 166, 1),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: widget.all.keys.map((key) {
                var data = widget.all[key];
                return locationcard(
                  heading: data['address'],
                  address: calculateDistanceNew(
                    data['location'].latitude,
                    data['location'].longitude,
                    context.read<Providers>().current_loc_data!.latitude,
                    context.read<Providers>().current_loc_data!.longitude,
                  ).toString() + ' km away from you',
                  coordinates: data['location'],
                  donationId: widget.donationId,
                  pickupId: widget.pickupId,
                );
              }).toList(),
            ),
          ),
        ),
        // SizedBox(
        //   height: 415,
        //   child: TabBarView(
        //     controller: _tabController,
        //     children: [
        //       _tab(0),
        //       _tab(1),
        //       _tab(2),
        //     ],
        //   ),
        // ),
      ]),
    );
  }
}
