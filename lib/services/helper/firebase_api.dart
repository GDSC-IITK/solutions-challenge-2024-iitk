// import 'dart:html' as html;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gdsc/services/helper/firebase_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token: $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  // static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
  //     Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  // static Future<List<FirebaseFile>> listAll(String path) async {
  //   final ref = FirebaseStorage.instance.ref(path);
  //   final result = await ref.listAll();

  //   final urls = await _getDownloadLinks(result.items);

  //   return urls
  //       .asMap()
  //       .map((index, url) {
  //         final ref = result.items[index];
  //         final name = ref.name;
  //         final file = FirebaseFile(ref: ref, name: name, url: url);

  //         return MapEntry(index, file);
  //       })
  //       .values
  //       .toList();
  // }

  // static Future downloadFile(Reference ref) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File("${dir.absolute}/${ref.name}");

  //   await ref.writeToFile(file);
  // }

  // void downloadFileURM(String url) {
  //   // Check if the platform is web before using dart:html
  //   if (kIsWeb) {
  //     html.AnchorElement anchorElement = html.AnchorElement(href: url)
  //       ..target = 'blank'
  //       ..download = url;
  //     anchorElement.click();
  //   } else {
  //     // Handle non-web platforms (e.g., mobile)
  //     // Implement the download logic for mobile here
  //     print('Downloading on non-web platform is not supported yet.');
  //   }
  // }
}
