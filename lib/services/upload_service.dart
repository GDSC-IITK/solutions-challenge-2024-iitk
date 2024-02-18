import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  final String? uid;
  UploadService({this.uid});

  //saving the User Data
  Future uploadPicture(String name, String folder) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? file = result.files.first.bytes;
      UploadTask task =
          FirebaseStorage.instance.ref().child("/$folder/$name").putData(file!);
    }
  }

  Future<List<String>> getListOfFiles(String folder) async {
    try {
      // Get a reference to the desired directory
      final storageRef = FirebaseStorage.instance.ref().child("/$folder");

      // Fetch all items and prefixes using listAll()
      final listResult = await storageRef.listAll();

      // Extract file names from the items
      return listResult.items.map((item) => item.name).toList();
    } catch (error) {
      print(error);
      // Handle errors appropriately
      return []; // Or throw an exception if necessary
    }
  }
}
