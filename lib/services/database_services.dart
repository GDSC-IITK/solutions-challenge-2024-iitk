import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  //saving the User Data
  Future savingUserData(String fullName, String email, String userName) async {
    return await userCollection
        .doc(uid)
        .set({"fullName": fullName, "email": email, "userName": userName});
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
