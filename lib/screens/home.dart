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
  Generate a concise, succinct, impactful and inspiring title for a donation activity that captures the essence of bridging donors and homeless individuals through our groundbreaking app ‘Feed Harmony’. The donation activity conveys the essence of combating hunger through community efforts. This title will be featured on the homepage of our app, 'Feed Harmony,' which facilitates the distribution of surplus food to the homeless and vulnerable populations. Our idea is to deliver free food to homeless people from restaurants and homes where food is extra, or somebody wants to donate. This title should resonate with the spirit of community and technological innovation, reflecting our commitment to ending hunger as part of the 17 UN SDGs. Utilise the provided JSON data detailing the donation's origin, whether it's from an individual or organisation, the donor's name, the quantity of food donated, the number of people served, and the receiver's name. The title should encapsulate the spirit of generosity, the action of giving, and the direct impact on recipients, all within a 4-8 word limit to ensure it is memorable and engaging for our app users. The title should be concise and designed to engage and inform users on our homepage. Each title must uniquely highlight the impact of the donation, fostering a sense of unity and purpose. Remember, your titles will inspire our users to continue contributing to a world where no one goes hungry.
  Your task is to creatively use the details provided in a structured JSON format, highlighting the donation's journey from donor to receiver and the collective impact on ending hunger. Do not include any ** or any other formatting; write simple text. The JSON contains critical data points: where the donation was picked up, whether the donor is an individual or an organisation, the donor's name, the quantity of food donated along with its weight metric, the number of people served, and the receiver's name.

Here's how to interpret the JSON for your title generation:

- *Donation picked from*: Extracted from ${prompt['donationData']['pickedFrom']}, indicates the source of the donation.
- *Individual or Organisation donated*: Determined by ${prompt['donationData']['isIndividual']}, specifies the type of donor.
- *Name of donor*: Found in ${prompt['donationData']['name']}, identifies the donor.
- *Quantity donated*: Combines ${prompt['donationData']['quantity']} and ${prompt['donationData']['weightMetric']} for the amount of food donated.
- *Number of people served*: Taken from ${prompt['noOfPeopleServed']}, shows the impact of the donation.
- *Receiver Name*: Located in ${prompt['receiverName']}, names the beneficiary.

Each title should uniquely highlight the generosity of the community and the app's role in facilitating these acts of kindness. Remember, your titles will not only be featured on our homepage but also serve to inspire and encourage others to join in our mission to ensure no one goes hungry.
''';

    String prompt_long = '''
  Create a captivating and succinct narrative that details the journey of a food donation within our 'Feed Harmony' initiative, aimed at addressing the global hunger challenge as outlined in the United Nations' Sustainable Development Goals (SDGs). Your narrative should unfold in a 4-8 line story format, clearly illustrating the process from the moment a generous donation is made, through the collection of surplus food from restaurants or homes, to the ultimate delivery to those in dire need. Your narrative should weave through the stages of donation, from the generous act of giving by individuals or organisations through the process of collection by our dedicated volunteers to the final delivery to those in need, all while emphasising the app’s role in combating hunger. Utilize the specific information provided from a JSON object about the donation, including the origin of the donation (individual or organization), the donor's identity, the type and amount of food donated, and the impact made (number of people served and the receiver's name). This story will be featured on our homepage, serving as a powerful testament to the impact of collective efforts in combating hunger. Aim to craft each narrative to be unique, reflecting the individual stories behind each donation and written in a manner that is both engaging and easy to understand for all our users. Your narrative should inspire action, foster a sense of community, and highlight the tangible difference made in the lives of recipients.
  Do not include any ** or any other formatting; write simple text. Here is the structure of the JSON data provided to you, which contains essential details of the donation process:

- *Donation picked from*: Use ${prompt['donationData']['pickedFrom']} to identify the donation's origin.
- *Individual or Organisation donated*: Refer to ${prompt['donationData']['isIndividual']} to specify if the donation was made by an individual or an organisation.
- *Name of donor*: Extract the donor's name from ${prompt['donationData']['name']}.
- *Quantity donated*: Combine ${prompt['donationData']['quantity']} and ${prompt['donationData']['weightMetric']} to describe the volume of the food donated.
- *Number of people served*: Highlight the impact of the donation using ${prompt['noOfPeopleServed']}.
- *Receiver Name*: Mention the recipient of the donation from ${prompt['receiverName']}.

Based on this information, construct a narrative of 4-8 lines that encapsulates the essence of this donation event. Your description should not only detail the flow of activities but also evoke the sense of community and purpose that drives the Feed Harmony initiative. Aim to inspire our users by illustrating how each donation contributes to our mission of ending hunger, making sure your narrative is engaging, clear, and understandable. Each story should reflect the individuality of every donation and the collective effort to make a difference."

Each description should uniquely highlight the generosity of the community and the app's role in facilitating these acts of kindness. Remember, your description will not only be featured on our homepage but also serve to inspire and encourage others to join in our mission to ensure no one goes hungry.
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
