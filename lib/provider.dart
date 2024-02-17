import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  late User? _user;

  UserProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  User? get user => _user;

  void updateUser(User? user) {
    _user = user;
    notifyListeners();
  }
}
