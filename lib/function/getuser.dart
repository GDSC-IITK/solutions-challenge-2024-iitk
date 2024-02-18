import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, String>> fetchData(String email) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Initialize an empty map to store user data
      Map<String, String> userData = {};

      // Get the first document in the query snapshot
      QueryDocumentSnapshot firstDocument = querySnapshot.docs.first;

      // Check if the data of the first document is not null
      Map<String, dynamic>? data =
          firstDocument.data() as Map<String, dynamic>?;
      if (data != null) {
        // Iterate over the data in the document and add it to the userData map
        data.forEach((key, value) {
          userData[key] = value.toString(); // Convert value to string if needed
        });
      }

      return userData;
    } else {
      print('User document does not exist');
      return {};
    }
  } catch (error) {
    print('Error fetching data: $error');
    return {};
  }
}

Future<Map<String, String>> fetchDataByUID(String uid) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    DocumentSnapshot querySnapshot = await users.doc(uid).get();

      // Check if the document exists
      if (querySnapshot.exists) {
        // Initialize an empty map to store user data
        Map<String, String> userData = {};

        // Get the data from the document
        Map<String, dynamic>? data = querySnapshot.data() as Map<String, dynamic>?;

        // Check if the data is not null
        if (data != null) {
          // Iterate over the data in the document and add it to the userData map
          data.forEach((key, value) {
            userData[key] = value.toString(); // Convert value to string if needed
          });
        }

        return userData;
      } else {
        // Document does not exist
        print('User document does not exist');
        return {}; // Return an empty map or handle the absence of data as needed
      }
  } catch (error) {
    print('Error fetching data: $error');
    return {};
  }
}
