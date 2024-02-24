import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/function/getuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc/services/gemini.dart';
import 'package:gdsc/services/helper/formatTimestamp.dart';
import 'package:provider/provider.dart';
import 'package:gdsc/provider.dart';

class HomePagenew extends StatefulWidget {
  HomePagenew({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePagenew> {
  List<String> imageUrls = [
    'assets/images/home_image.jpeg',
    'assets/images/home_image.jpeg',
    'assets/images/home_image.jpeg',
    'assets/images/home_image.jpeg',
    'assets/images/home_image.jpeg',
    'assets/images/home_image.jpeg',
  ];

  String _userMail = "";
  String _UserName = "";
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    loadData();
  }

  Future<Map<String, dynamic>> loadData() async {
    List<Map<String, dynamic>> data = [];

    try {
      // Get reference to the collection
      CollectionReference collection =
          FirebaseFirestore.instance.collection('HomePage');

      // Get all documents from the collection
      QuerySnapshot querySnapshot = await collection.get();

      // Create an empty map to store document data
      Map<String, dynamic> documentsMap = {};

      // Loop through each document and add it to the map
      querySnapshot.docs.forEach((doc) {
        data.add(doc.data() as Map<String, dynamic>);
      });

      setState(() {
        _data = data;
        print(data.length);
      });
      // Return the map of document data
      return documentsMap;
    } catch (error) {
      // Handle any errors that might occur
      print('Error fetching documents: $error');
      return {}; // Return an empty map in case of error
    }
  }

  // Function to load user's name from Firebase
  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userMail = user.email ?? "";
      });
      Map<String, String> userData = await fetchData(_userMail);
      setState(() {
        _UserName = userData['userName'] ?? '';
      });
    }
  }

  Future<String> makePayload(Map<String, dynamic> prompt) async {
    // Filter out values that are not string or int
    Map<String, dynamic> filteredPrompt = {};
    prompt.forEach((key, value) {
      if (value is String || value is int) {
        filteredPrompt[key] = value;
      }
    });

    // Convert the filtered map to a stringified JSON
    String jsonString = json.encode(filteredPrompt);
    print(jsonString);

    // Further processing or logging if needed
    // ...

    return jsonString;
  }

  Future<Map> retRes(Map<String, dynamic> prompt) async {
    print(prompt);

    String prompt_short = '''
  We are building a social initiative for solving the hunger problem out of the 17 SDGs of the United Nations. Our idea is to deliver free food to homeless people from restaurants and homes where food is extra or somebody wants to donate. We have a json where we have all the details of the food posted by someone to a homeless person. I will provide you with the json. You have to write one line of 4-8 words about the whole donation thing in short. We will put this on our homepage where all users can see. Keep it short, clear, and understandable. Here is the json:
  Donation picked from: ${prompt['donationData']['pickedFrom'] ?? ''}
  Individual or Organisation donated: ${prompt['donationData']['isIndividual'] == true ? "Individual" : "Organisation"}
  Name of donor: ${prompt['donationData']['name'] ?? ''}
  Quantity donated: ${prompt['donationData']['quantity'] ?? '' + prompt['donationData']['weightMetric'] ?? ''}
  Number of people served: ${prompt['noOfPeopleServed'] ?? ''}
  Receiver Name: ${prompt['receiverName'] ?? ''}
  Now write the prompt for this as explained. Do not include any ** or any other formatting, write simple text.
  You will be sent a lot of this prompts. Make sure you write unique responses for each.
''';

    String prompt_long = '''
  We are building a social initiative for solving the hunger problem out of the 17 SDGs of the United Nations. Our idea is to deliver free food to homeless people from restaurants and homes where food is extra or somebody wants to donate. We have a json where we have all the details of the food posted by someone to a homeless person. I will provide you with the json. You have to write one line of 4-8 lines about the whole donation thing in details. Discuss the flow that happened, first the food was donated, then picked up then given to someone needy. We will put this on our homepage where all users can see. Keep it short, clear, and understandable. Here is the json:
  Donation picked from: ${prompt['donationData']['pickedFrom'] ?? ''}
  Individual or Organisation donated: ${prompt['donationData']['isIndividual'] == true ? "Individual" : "Organisation"}
  Name of donor: ${prompt['donationData']['name'] ?? ''}
  Quantity donated: ${prompt['donationData']['quantity'] ?? '' + prompt['donationData']['weightMetric'] ?? ''}
  Number of people served: ${prompt['noOfPeopleServed'] ?? ''}
  Receiver Name: ${prompt['receiverName'] ?? ''}
  Now write the prompt for this as explained. Do not include any ** or any other formatting, write simple text.
  You will be sent a lot of this prompts. Make sure you write unique responses for each. Make this like an engaging story.
''';
    print(prompt_short);
    String res = await returnReponse(prompt_short);
    String res1 = await returnReponse(prompt_long);

    return {"res": res, "res1": res1};
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String userName = userProvider.user?.displayName ?? 'Guest';
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 1,
        children: List.generate(_data.length, (index) {
          var imageUrl = _data[index]['imageLink'];
          var title = "";
          var distance = "";

          // Use await to get the result of the future
          return FutureBuilder<Map>(
            future: retRes(_data[index]), // Use the correct index and argument
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Check if the future has completed
                String result = snapshot.data!['res'] ??
                    ""; // Get the result from the snapshot
                String result1 = snapshot.data!['res1'] ??
                    ""; // Get the result from the snapshot
                title = result; // Assign the result to the title
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Details'),
                          backgroundColor: Colors.white,
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Title: ${title ?? ""}'),
                                SizedBox(height: 8),

                                Text(
                                    'Food donated at: ${formatDateAndTime(_data[index]['createdAt'])['date'] ?? ""}'),
                                SizedBox(height: 8),

                                Text(
                                    'Time: ${formatDateAndTime(_data[index]['createdAt'])['time'] ?? ""}'),
                                SizedBox(height: 8),

                                Text('${result1 ?? ""}'),
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Generated by',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    SizedBox(width: 8),
                                    Image.asset(
                                      'assets/images/gemini.png',
                                      height: 36,
                                      width: 36,
                                      // Adjust height and width as needed
                                    ),
                                    SizedBox(width: 4),
                                    // Text(
                                    //   'Gemini',
                                    //   style: TextStyle(
                                    //       fontSize: 14, color: Colors.grey),
                                    // ),
                                  ],
                                ),
                                // Add more details as needed
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 8.0, end: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                      height:
                                          4), // Add spacing between title and date
                                  Text(
                                    'Date: ${formatDateAndTime(_data[index]['createdAt'])['date'] ?? ""}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Time: ${formatDateAndTime(_data[index]['createdAt'])['time'] ?? ""}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  // Add distance widget here if needed
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Show a placeholder or loading indicator while the future is not yet complete
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        }),
      ),
    );
  }
}
