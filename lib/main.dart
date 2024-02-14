import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gdsc/firebase_options.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: _isSignedIn ? const LoginPage() : const WelcomePage(),
    );
  }
}
