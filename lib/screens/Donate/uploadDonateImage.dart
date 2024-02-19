import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:gdsc/services/providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class DonateUploadImageWidget extends StatefulWidget {
  final Function(String)? onImageUploaded;

  const DonateUploadImageWidget({Key? key, this.onImageUploaded}) : super(key: key);

  @override
  _DonateUploadImageWidgetState createState() =>
      _DonateUploadImageWidgetState();
}

class _DonateUploadImageWidgetState extends State<DonateUploadImageWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String _UserName = "";
  String _UserId = "";
  String _userMail = "";

  get io => null;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
    _uploadImageToFirebaseStorage(image, "Donations", _UserName)
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
    _uploadImageToFirebaseStorage(image, "Users", _UserName);
  }

  Future<String> _uploadImageToFirebaseStorage(
      XFile? _imageFile, folder, name) async {
    print("uploading image");
    if (_imageFile != null) {
      try {
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
        print('Error uploading image to Firebase Storage: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image to be uploaded is null')),
      );
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          // Show dialog to select camera or gallery
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
          // Upload image to Firebase Storage
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(199, 255, 255, 255),
            shape: BoxShape.circle,
            // Add boxShadow if needed
            // boxShadow: [
            //   BoxShadow(
            //     offset: Offset(0, 4),
            //     blurRadius: 4,
            //     color: Color(0xFF000000),
            //     spreadRadius: 0.8,
            //   ),
            // ],
          ),
          child: GestureDetector(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 255, 255,
                      255), // Change the color to match your app's theme
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white12,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    // SizedBox(width: 10),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
