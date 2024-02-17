import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, String>> fetchData(String email) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      String fullName = querySnapshot.docs.first.get('fullName');
      String userName = querySnapshot.docs.first.get('userName');

      // Construct a map containing the user data
      Map<String, String> userData = {
        'fullName': fullName,
        'userName': userName,
      };

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
