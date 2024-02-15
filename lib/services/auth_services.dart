import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/services/database_services.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Login Function.
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != Null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Register a New User Function
  Future registerUserWithEmailandPassword(
      String fullName, String email, String password, String userName) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid)
            .savingUserData(fullName, email, userName);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
