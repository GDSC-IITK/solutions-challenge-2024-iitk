import 'package:flutter/material.dart';
import 'package:gdsc/screens/Profile/profilemain.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/signup_page.dart';
import 'package:gdsc/screens/Volunteer/volunteer.dart';
import 'screens/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const LoginPage() : const Profilemain(),
    );
  }
}
