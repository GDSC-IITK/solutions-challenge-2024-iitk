import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc1;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/services/helper/getCurrentLoc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class spotSomeone extends StatefulWidget {
  const spotSomeone({super.key});

  @override
  State<spotSomeone> createState() => spotSomeoneState();
}

class spotSomeoneState extends State<spotSomeone> {
  bool _isLoading = false;
  bool _isLoadingAll = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String _UserName = "";
  String _UserId = "";
  String _userMail = "";
  String _downloadLink = "";
  List<String> _images = [];
  Completer<GoogleMapController> _controller = Completer();
  final loc1.Location _location = loc1.Location();
  LatLng _coordinates = LatLng(0, 0);

  GeoPoint? _currentLoc = GeoPoint(0, 0);
  static CameraPosition loc =
      const CameraPosition(target: LatLng(26.511639, 80.230954), zoom: 14);

  List<Marker> _marker = [];
  final List<Marker> _list = [
    const Marker(
        markerId: MarkerId("1"),
        position: LatLng(26.514323, 80.231223),
        infoWindow: InfoWindow(title: "Current position"))
  ];
  StreamSubscription<loc1.LocationData>? _locationSubscription;
  LatLng _currentLocation = LatLng(0, 0);
  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    loadData();
    _startLocationTracking();
    _loadUserName();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    try {
      var locationData = await _location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
        _marker.add(
          Marker(
            markerId: MarkerId("currentLocation"),
            position: _currentLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );
      });

      _locationSubscription =
          _location.onLocationChanged.listen((loc1.LocationData locationData) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          _marker.add(
            Marker(
              markerId: MarkerId("currentLocation"),
              position: _currentLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
          );
        });
        _moveCameraToCurrentLocation();
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _moveCameraToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  Future<Uint8List?> createCurrentLocationMarker() async {
    final double markerSize = 50.0; // Adjust the size of the marker as needed
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paintCircle = Paint()
      ..color = const ui.Color.fromARGB(
          255, 12, 68, 14); // Green color for the circle

    // Draw the circle for the marker
    canvas.drawCircle(
      Offset(markerSize / 2, markerSize / 2), // Center of the circle
      markerSize / 2, // Radius of the circle
      paintCircle,
    );

    // Convert the canvas to an image
    final img = await pictureRecorder
        .endRecording()
        .toImage(markerSize.toInt(), markerSize.toInt());
    final imgByteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return imgByteData?.buffer.asUint8List();
  }

  loadData() async {
    Uint8List? markerIcon = await createCurrentLocationMarker();

    GeoPoint? _currentLocTemp = await getCurrentLocation(context);
    setState(() {
      _currentLoc = _currentLocTemp;
      print(_currentLoc);
      _marker.add(Marker(
          markerId: MarkerId("2"),
          position:
              LatLng(_currentLocTemp!.latitude, _currentLocTemp!.longitude),
          icon: BitmapDescriptor.fromBytes(markerIcon!),
          infoWindow: InfoWindow(title: "My Current location")));
    });
  }

  // Future<Position> getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) {
  //     print("Error$error");
  //   });
  //   return await Geolocator.getCurrentPosition();
  // }

  // loadData() {
  //   getUserCurrentLocation().then((value) async {
  //     print("My Current Location");
  //     print("${value.latitude} ${value.longitude}");
  //     _marker.add(
  //       Marker(
  //           markerId: MarkerId("2"),
  //           position: LatLng(value.latitude, value.longitude),
  //           infoWindow: InfoWindow(title: "My Current location")),
  //     );
  //     CameraPosition cameraPosition = CameraPosition(
  //         zoom: 14, target: LatLng(value.latitude, value.longitude));

  //     final GoogleMapController controller = await _controller.future;
  //     controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   });
  //   setState(() {});
  // }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
    _uploadImageToFirebaseStorage(image, "Spot", _UserName)
        .then((value) => null);
  }

  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String id = user.uid ?? "";
      Map<String, String> userData = await fetchDataByUID(id);
      print(userData);
      print("user data");
      setState(() {
        _UserName = userData['userName'] ?? '';
        _UserId = user.uid;
        if (user.email!.isNotEmpty) {
          _userMail = user.email!;
        } else {
          _userMail = userData['email'] ?? '';
        }
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
    _uploadImageToFirebaseStorage(image, "Spot", _UserName);
  }

  Future<String> _uploadImageToFirebaseStorage(
      XFile? _imageFile, folder, name) async {
    print("uploading image");
    if (_imageFile != null) {
      try {
        _isLoading = true;
        // Upload the image to Firebase Storage
        print(_imageFile);
        print("image file");
        final firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(
                '${folder}/${_UserId}_${DateTime.now().millisecondsSinceEpoch}');
        print(ref);
        print("ref");
        await ref.putFile(File(_imageFile!.path));
        // Get the download URL of the uploaded image
        String downloadURL = await ref.getDownloadURL();
        // TODO: Save the download URL to user's profile data
        print('Image uploaded to Firebase Storage: $downloadURL');
        setState(() {
          _isLoading = false;
          _downloadLink = downloadURL;
          _images.add(downloadURL);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded')),
        );
        return downloadURL;
        // final QuerySnapshot emailQuery = await FirebaseFirestore.instance
        //     .collection("Users")
        //     .where("email", isEqualTo: _userMail)
        //     .get();
        // print(_userMail);
        // print("email query");
        // await emailQuery.docs.first.reference.update(
        //     {'profileImageLink': downloadURL, 'updatedAt': Timestamp.now()});
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print('Error uploading image to Firebase Storage: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image to be uploaded is null')),
      );
    }
    return '';
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

  @override
  Widget build(BuildContext context) {
    Future<void> call(String number) async {
      final Uri url = Uri(scheme: "tel", path: number);
      if (!await launchUrl(url))
        print("Unable to launch Url");
      else
        launchUrl(url);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Spot Someone in Need",
          style: TextStyle(fontFamily: "Inter"),
        ),
      ),
      body: Container(
        color: const Color(0xFF024EA6),
        child: Stack(
          children: [
            if (_isLoadingAll)
              Center(
                child: AlertDialog(
                  title: Text('Processing'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Please wait...'),
                    ],
                  ),
                ),
              ),
            Column(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: 580,
                    child: GoogleMap(
                      onTap: (LatLng latlng) {
                        _marker.add(
                          Marker(
                              markerId: MarkerId("3"),
                              position: latlng,
                              infoWindow: InfoWindow(title: "Destination")),
                        );
                        setState(() {
                          _coordinates = latlng;
                        });
                      },
                      initialCameraPosition: loc,
                      markers: Set<Marker>.of(_marker),
                      // mapType: MapType.satellite,
                      //compassEnabled: false,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: 170,
                    width: double.infinity,
                    color: const Color(0xFF024EA6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            'Click anywhere on the map to select a location',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        InkWell(
                          onTap: () {
                            if (_downloadLink == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please upload image to continue')),
                              );
                            } else if (_coordinates.latitude == 0 &&
                                _coordinates.longitude == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please mark a location on the map')),
                              );
                            } else {
                              // Open dialog box for user input
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Initialize text editing controllers for text fields
                                  TextEditingController peopleController =
                                      TextEditingController();
                                  TextEditingController ageController =
                                      TextEditingController();
                                  TextEditingController nameController =
                                      TextEditingController();
                                  TextEditingController landmarkController =
                                      TextEditingController();
                                  TextEditingController remarkController =
                                      TextEditingController();

                                  return !_isLoadingAll
                                      ? AlertDialog(
                                          title: Text(
                                              'Enter Additional Information'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: peopleController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Number of people present'),
                                              ),
                                              TextField(
                                                controller: ageController,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Approximate age (or ages)'),
                                              ),
                                              TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Name of 1 or more people'),
                                              ),
                                              TextField(
                                                controller: landmarkController,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Nearby Landmark'),
                                              ),
                                              TextField(
                                                controller: remarkController,
                                                decoration: InputDecoration(
                                                    labelText: 'Remarks'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                // Check if all data is present and not empty
                                                if (peopleController
                                                        .text.isEmpty ||
                                                    ageController
                                                        .text.isEmpty ||
                                                    nameController
                                                        .text.isEmpty ||
                                                    landmarkController
                                                        .text.isEmpty ||
                                                    remarkController
                                                        .text.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Please fill in all fields'),
                                                    ),
                                                  );
                                                } else {
                                                  // Perform action if all data is present
                                                  // You can access the entered data using the text editing controllers
                                                  // For example:
                                                  setState(() {
                                                    _isLoadingAll = true;
                                                  });
                                                  FirebaseFirestore firestore =
                                                      FirebaseFirestore
                                                          .instance;
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;
                                                  if (user != null) {
                                                    String people =
                                                        peopleController.text;
                                                    String age =
                                                        ageController.text;
                                                    String name =
                                                        nameController.text;
                                                    String remarks =
                                                        remarkController.text;
                                                    String landmark =
                                                        landmarkController.text;
                                                    GeoPoint? currentLocation =
                                                        await getCurrentLocation(context);
                                                    GeoPoint? enteredLocation =
                                                        GeoPoint(
                                                            _coordinates
                                                                .latitude,
                                                            _coordinates
                                                                .longitude);
                                                    String
                                                        locationLandmarkCurrent =
                                                        await getLocationFromGeoPoint(
                                                            currentLocation!);
                                                    String
                                                        locationLandmarkEntered =
                                                        await getLocationFromGeoPoint(
                                                            enteredLocation);
                                                    var payload = {
                                                      'address':
                                                          locationLandmarkEntered ??
                                                              {},
                                                      'addressCurrent':
                                                          locationLandmarkCurrent ??
                                                              {},
                                                      'remarks': remarks,
                                                      'createdAt':
                                                          Timestamp.now(),
                                                      'updatedAt':
                                                          Timestamp.now(),
                                                      'nearbyLandmark':
                                                          landmark,
                                                      'location':
                                                          enteredLocation,
                                                      'locationCurrent':
                                                          currentLocation,
                                                      'noOfPeople':
                                                          int.parse(people),
                                                      'ageGroup': age,
                                                      'nameGroup': name,
                                                      'imageLink': _images,
                                                      'userId': user.uid,
                                                    };
                                                    print(payload);
                                                    var drop = await firestore
                                                        .collection(
                                                            'DatabaseLocations')
                                                        .add(payload);
                                                    String id =
                                                        user.email ?? "";
                                                    CollectionReference users =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Users');

                                                    QuerySnapshot
                                                        querySnapshot =
                                                        await users
                                                            .where('email',
                                                                isEqualTo: id)
                                                            .get();
                                                    int donationsDone =
                                                        querySnapshot.docs.first
                                                                .get(
                                                                    'spotsDone') ??
                                                            0;

                                                    if (querySnapshot
                                                        .docs.isNotEmpty) {
                                                      DocumentSnapshot
                                                          docSnapshot =
                                                          querySnapshot
                                                              .docs.first;

                                                      // Update the data in the document
                                                      await docSnapshot
                                                          .reference
                                                          .update({
                                                        // Specify the fields you want to update along with their new values
                                                        // For example:
                                                        'spotIds': FieldValue
                                                            .arrayUnion(
                                                                [drop.id]),
                                                        'spotsDone':
                                                            donationsDone + 1,
                                                        'updatedAt':
                                                            Timestamp.now()
                                                        // Add more fields as needed
                                                      });
                                                    }
                                                    setState(() {
                                                      _isLoadingAll = false;
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor: Colors
                                                            .green, // Set background color to green
                                                        content: Text(
                                                          'Data was successfully saved',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black), // Set text color to black
                                                        ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      ),
                                                    );
                                                    // Perform further actions with the entered data
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                    nextScreenReplace(
                                                        context, HomePage());
                                                  }
                                                }
                                              },
                                              child: _isLoadingAll ?Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 16),
                                              Text('Please wait...'),
                                            ],
                                          ): Text('Submit'),
                                            ),
                                          ],
                                        )
                                      : AlertDialog(
                                          title: Text('Processing'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 16),
                                              Text('Please wait...'),
                                            ],
                                          ),
                                        );
                                },
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: Color.fromARGB(255, 72, 129, 194)),
                            height: 49,
                            width: 311,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_sharp,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Upload Landmark",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Inter",
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Change Profile Image'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text('Take Photo'),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          _getImageFromCamera();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.image),
                                        title: Text('Choose from Gallery'),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          _getImageFromGallery();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: Color.fromARGB(255, 72, 129, 194)),
                            height: 49,
                            width: 311,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: !_isLoading
                                        ? Text(
                                            '${_downloadLink == '' ? 'Add Image' : 'Add Other Image (${_images.length})'}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Inter",
                                                fontSize: 20),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(top: 15.0),
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       print("My Current Location");
      //       getUserCurrentLocation().then((value) async {
      //         print("${value.latitude} ${value.longitude}");
      //         _marker.add(
      //           Marker(
      //               markerId: MarkerId("2"),
      //               position: LatLng(value.latitude, value.longitude),
      //               infoWindow: InfoWindow(title: "My Current location")),
      //         );
      //         CameraPosition cameraPosition = CameraPosition(
      //             zoom: 16, target: LatLng(value.latitude, value.longitude));

      //         final GoogleMapController controller = await _controller.future;
      //         controller.animateCamera(
      //             CameraUpdate.newCameraPosition(cameraPosition));
      //       });
      //       setState(() {});
      //     },
      //     child: Icon(Icons.location_disabled_outlined),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
