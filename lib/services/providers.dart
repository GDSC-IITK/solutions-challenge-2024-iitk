import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/data_models/user.dart';

class Providers with ChangeNotifier {
 User _user = User(
    "id",
    "fullName",
    "userName",
    0,
    "mobileNumber",
    GeoPoint(0, 0),
    Timestamp.now(),
    Timestamp.now(),
    [],
    [],
    0,
    "email",
  );
  User get user_data => _user;
  void setUser(User value) {
    _user = value;
    notifyListeners();
  }
  Future<void> setUserFromFirestoreEmail(String email) async {
    final QuerySnapshot emailQuery = await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get();
      print(email);
      print("user11");

    if (emailQuery.docs.isNotEmpty) {
      final Map<String, dynamic> userData = emailQuery.docs.first.data() as Map<String, dynamic>;
      print(userData);
      final User user = User.fromJson(userData);
      setUser(user);
    } else {
      // Handle case when user data is not found
    }
  }

    Future<void> setUserFromFirestorePhone(String phone) async {
    final QuerySnapshot emailQuery = await FirebaseFirestore.instance
        .collection("Users")
        .where("phoneNumber", isEqualTo: phone)
        .get();

    if (emailQuery.docs.isNotEmpty) {
      final Map<String, dynamic> userData = emailQuery.docs.first.data() as Map<String, dynamic>;
      final User user = User.fromJson(userData);
      setUser(user);
    } else {
      // Handle case when user data is not found
    }
  }
}