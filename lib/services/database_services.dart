import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  //saving the User Data
  Future<void> savingUserData(
      String fullName, String email, String userName) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("Users");

    // Check if the provided username is unique
    userName = await ensureUniqueUsername(userName);

    // Save user data to the 'Users' collection
    await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "userName": userName,
      "createdAt": Timestamp.now(),
      "updatedAt": Timestamp.now(),
      "currentLocation": "",
    });
  }

   Future<void> savingUserDataAll(
      String fullName, String email, String age, String userName) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection("Users");

    // Check if the provided username is unique
    userName = await ensureUniqueUsername(userName);

    // Save user data to the 'Users' collection
    await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "userName": userName,
      "createdAt": Timestamp.now(),
      "updatedAt": Timestamp.now(),
      "age": age,
      "currentLocation": "",
    });
  }

  Future<String> ensureUniqueUsername(String baseUsername) async {
    final CollectionReference userNamesCollection =
        FirebaseFirestore.instance.collection("Userames");
    // Check if the base username already exists
    QuerySnapshot usernameQuery = await userNamesCollection
        .where("username", isEqualTo: baseUsername)
        .get();
    if (usernameQuery.docs.isEmpty) {
      // Base username is unique
      return baseUsername;
    } else {
      // Generate a unique username
      return await generateUniqueUsername(baseUsername, userNamesCollection);
    }
  }

  Future<String> generateUniqueUsername(
      String baseUsername, CollectionReference userNamesCollection) async {
    int suffix = 1;
    String username = baseUsername;

    // Keep generating new usernames until a unique one is found
    while (true) {
      QuerySnapshot usernameQuery = await userNamesCollection
          .where("username", isEqualTo: username)
          .get();
      if (usernameQuery.docs.isEmpty) {
        // Unique username found
        // Update the 'Usernames' collection with the new username
        await userNamesCollection.add({
          "username": username,
          "userId": uid,
        });
        print("aaddding new username");
        return username;
      } else {
        // Append a suffix to the base username and try again
        username = '$baseUsername$suffix';
        suffix++;
      }
    }
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
