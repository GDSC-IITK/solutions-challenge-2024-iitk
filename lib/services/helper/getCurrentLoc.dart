
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<GeoPoint?> getCurrentLocation(BuildContext context) async {
  try {
    // Check if location permission is granted
    if (!(await Permission.location.isGranted)) {
      // If not granted, request permission
      PermissionStatus permissionStatus = await Permission.location.request();
      
      // If permission is denied, show an alert
      if (permissionStatus != PermissionStatus.granted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permission Required'),
              content: Text('This app requires location permission to function properly. Please enable location access in the device settings.'),
              actions: <Widget>[
                TextButton(
                   onPressed: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.location);
                    },
                  child: Text('Open Settings'),
                ),
              ],
            );
          },
        );
        return null;
      }
    }
    
    // Get current position if permission is granted
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;
    print('latitude ${latitude} longitude ${longitude}');
    return GeoPoint(latitude, longitude);
  } catch (e) {
    print('Error getting current location: $e');
    return null;
  }
}
