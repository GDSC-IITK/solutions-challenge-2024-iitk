import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/screens/login_page.dart';
import 'package:gdsc/widgets/nextscreen.dart';

class UpdatePasswordScreen extends StatelessWidget {
Future<void> changePassword(String oldPassword, String newPassword) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      // Reauthenticate the user with their current credentials (old password)
      final credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(credential);

      // Reauthentication successful, update the password
      await user.updatePassword(newPassword);
      debugPrint('Password has been changed successfully');
      nextScreen(BuildContext, LoginPage());
    } catch (error) {
      // Reauthentication failed, handle the error
      debugPrint('Error changing password: $error');
      // You can show an error message to the user or handle the error as needed
    }
  } else {
    debugPrint("No user is signed in.");
    // No user is signed in, handle this case accordingly
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Password',
          style: TextStyle(fontFamily: "Inter", color: Colors.white),
        ),
        backgroundColor:
            Color(0xFF024EA6), // Set your desired app bar color here
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<User?>(
            future: FirebaseAuth.instance.authStateChanges().first,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while checking authentication state
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data == null) {
                return Text(
                    'User not authenticated'); // Show a message if user is not authenticated
              }
              final List<String> providerIds = snapshot.data!.providerData
                  .map((info) => info.providerId)
                  .toList();
              if (!providerIds.contains('password')) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Password cannot be changed\nYou are authenticated with: ${providerIds.join(', ')}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Material(
                elevation: 4,
                shadowColor: Color(0xFF000000),
                child: ListTile(
                  tileColor: Color(0xFFCAE3FF),
                  title: Text(
                    "Update Password",
                    style: TextStyle(
                      fontFamily: "Inter",
                    ),
                  ),
                  onTap: () async {
                    String? oldPassword =
                        await _showPasswordDialog(context, 'Old Password');
                    if (oldPassword != null) {
                      String? newPassword =
                          await _showNewPasswordDialog(context);
                      if (newPassword != null) {
                        try {
                          await changePassword(oldPassword,newPassword);
                          print('Password updated successfully');
                        } catch (error) {
                          print('Error updating password: $error');
                          // Handle error updating password
                        }
                      }
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String?> _showPasswordDialog(BuildContext context, String title) {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter password'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showNewPasswordDialog(BuildContext context) {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter new password'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm new password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newPassword = newPasswordController.text;
                String confirmPassword = confirmPasswordController.text;
                if (newPassword == confirmPassword) {
                  Navigator.pop(context, newPassword);
                } else {
                  // Show an error message if passwords do not match
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
