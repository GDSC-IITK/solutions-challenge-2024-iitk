import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:gdsc/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/screens/vision_page.dart';
import 'package:gdsc/screens/welcome_page.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/provider.dart'; // Import your Provider class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF024EA6), // Set your desired status bar color here
    ));
    return MultiProvider(
      // Use MultiProvider if you have multiple providers
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
          value: UserProvider(), // Provide your UserProvider instance
        ),
        // Add other providers if needed
      ],
      child: MaterialApp(
      //   theme: ThemeData(
      //   appBarTheme: AppBarTheme(
      //     color: Color(0xFF024EA6), // Set your desired app bar color here
      //   ),
      // ),
        title: 'Feed Harmony',
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return VisionPage();
        } else {
          return VisionPage();
        }
      },
    );
  }
}
