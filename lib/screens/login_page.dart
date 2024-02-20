import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/function/generateUserName.dart';
import 'package:gdsc/screens/OTP_page.dart';
import 'package:gdsc/screens/home/home_page.dart';
import 'package:gdsc/screens/phone_login_page.dart';
import 'package:gdsc/services/database_services.dart';
import 'package:gdsc/widgets/nextscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gdsc/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc/provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      nextScreen(context, HomePage());
      // User successfully logged in
      print('User logged in successfully!');

      // You can navigate to the next screen or perform other actions here
    } catch (error) {
      String errorCode = (error as FirebaseAuthException).code;
      // Handle different error cases
      switch (errorCode) {
        case 'user-not-found':
          // Handle when user does not exist
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No user found with this email. Please register!'),
            ),
          );
          print('No user found with this email. Please register!');
          break;
        case 'wrong-password':
          // Handle when password is incorrect
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incorrect password. Please try again!'),
          ));
          print('Incorrect password. Please try again!');
          break;
        default:
          // Handle other errors
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $error'),
          ));
          print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(78, 134, 199, 0.83),
                  Color.fromRGBO(20, 61, 108, 1),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20.0),
                          Image.asset(
                            'assets/images/img.png',
                            height: 250,
                            width: 100,
                          ),
                          SizedBox(height: 80.0),
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Email address',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 13),
                              filled: true,
                              fillColor: Color.fromARGB(255, 110, 136, 189),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 13),
                              filled: true,
                              fillColor: Color.fromARGB(255, 110, 136, 189),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              loginUserWithEmailAndPassword(
                                  _emailController.text,
                                  _passwordController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhoneLoginPage()),
                              );
                            },
                            child: Text(
                              'Get OTP to log in without password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  height: 1.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  height: 1.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          RawMaterialButton(
                            onPressed: () async {
                             userCredential.value = await signInWithGoogle();
                            if (userCredential.value != null)
                            {
                              print(userCredential.value.user!.email);
                              nextScreen(context, HomePage());
                            }
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.jpg',
                                  height: 40.0,
                                  width: 40.0,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Future<void> signInWithEmailAndPassword(
      String emailOrUsername, String password) async {
    try {
      bool isEmail = emailOrUsername.contains('@');

      String email = '';

      if (isEmail) {
        email = emailOrUsername;
      } else {
        email = await getUserEmailByUsername(emailOrUsername);
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        print('User signed in successfully: ${user.uid}');
        // nextScreenReplace(context, HomePage());
        Provider.of<UserProvider>(context, listen: false).updateUser(user);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        print('Failed to sign in with email and password');
      }
    } catch (error) {
      print('Error signing in with email and password: $error');
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final CollectionReference userCollection =
            FirebaseFirestore.instance.collection("Users");
        QuerySnapshot querySnapshot = await userCollection
            .where('email', isEqualTo: googleUser?.email)
            .get();
        print(querySnapshot);
        if (querySnapshot.docs.isEmpty) {
          // If user doesn't exist, add their data to Firestore
          await DatabaseService(uid: googleUser?.id).savingUserData(
              googleUser?.displayName ?? "",
              googleUser?.email ?? "",
              generateUsername(googleUser?.email ?? "", googleUser?.displayName ?? "")
              );
        }

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String> getUserEmailByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('userName', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('email');
      } else {
        // If no matching document is found, throw an error
        throw 'User not found';
      }
    } catch (error) {
      print('Error retrieving user email: $error');
      throw error;
    }
  }
}
