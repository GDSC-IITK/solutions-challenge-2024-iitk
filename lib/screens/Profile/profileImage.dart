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

class ProfileImageWidget extends StatefulWidget {
  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
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
    _uploadImageToFirebaseStorage(image, "Users", _UserName);
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

  //  Future uploadFile() async {
  //   if (_imageFile == null) return;
  //   final fileName = "sahil.jpg";
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('file/');
  //     await ref.putFile(_imageFile! as File);
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  Future<void> _uploadImageToFirebaseStorage(
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

        final QuerySnapshot emailQuery = await FirebaseFirestore.instance
            .collection("Users")
            .where("email", isEqualTo: _userMail)
            .get();
        print(_userMail);
        print("email query");
        await emailQuery.docs.first.reference.update(
            {'profileImageLink': downloadURL, 'updatedAt': Timestamp.now()});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded')),
        );
      } catch (error) {
        print('Error uploading image to Firebase Storage: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image to be uploaded is null')),
      );
    }
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundImage: _imageFile != null
                    ? FileImage(File(_imageFile!.path))as ImageProvider<Object>?
                    : NetworkImage(context
                          .read<Providers>()
                          .user_data
                          .toJson()['profileImageLink']
                          .toString()),
              ),
              Center(
                child: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 3, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
