import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

Future<GeoPoint?> getCurrentLocation() async {
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;
    print('latitude ${latitude} longitude ${longitude}');
    return GeoPoint( latitude, longitude);
  } catch (e) {
    print('Error getting current location: $e');
    return null;
  }
}
