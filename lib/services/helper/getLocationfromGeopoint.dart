import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

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

double calculateDistanceNew(double lat1,double lon1,double lat2,double lon2) {
  print(lat1);
  print(lon1);
  print(lat2);
  print(lon2);
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

double radians(double degrees) {
  return degrees * (pi / 180);
}
