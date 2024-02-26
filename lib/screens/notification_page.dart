import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem {
  final String date;
  final String heading;
  final String content;
  final IconData icon;
  final String time;
  final Timestamp timestamp;

  NotificationItem({
    required this.date,
    required this.heading,
    required this.content,
    required this.icon,
    required this.time,
    required this.timestamp,
  });
}

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notificationItems = [];
  bool _isLoading = false;
  List<NotificationItem> notificationItemsFiltered = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotificationItems().then((notifs) {
      setState(() {
        notificationItems = notifs;
        print(notifs);
      });
    });
  }

  // final List<NotificationItem> notifications = [
  //   NotificationItem(
  //     date: 'Today',
  //     heading: 'Donation completed, make a valuable review',
  //     content:
  //         'Lorem ipsum dolor sit amet. Et architecto sequi sed aperiam autem ea consequuntur vero ut omnis sint qui voluptate quidem in deserunt recusandae.',
  //     icon: Icons.event,
  //     time: 'At 05:57 Pm',
  //   ),
  //   NotificationItem(
  //     date: 'Today',
  //     heading: 'Your Donation is cancelled',
  //     content:
  //         'Lorem ipsum dolor sit amet. Et architecto sequi sed aperiam autem ea consequuntur vero ut omnis sint qui voluptate quidem in deserunt recusandae.',
  //     icon: Icons.event,
  //     time: 'At 05:57 Pm',
  //   ),
  //   NotificationItem(
  //     date: 'Yesterday',
  //     heading: 'Volunteers are ready',
  //     content:
  //         'Lorem ipsum dolor sit amet. Et architecto sequi sed aperiam autem ea consequuntur vero ut omnis sint qui voluptate quidem in deserunt recusandae.',
  //     icon: Icons.event,
  //     time: 'At 05:57 Pm',
  //   ),
  //   // Add more notifications here
  // ];

  Map<String, String> formatDateAndTime(Timestamp timestamp) {
    // Convert the Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the date
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    // Format the time
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Create a map to store date and time
    Map<String, String> dateTimeMap = {
      'date': formattedDate,
      'time': formattedTime,
    };

    return dateTimeMap;
  }

  String formatDate(Timestamp timestamp) {
    // Convert the Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format the date
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    // Get the current date
    DateTime currentDate = DateTime.now();
    String currentFormattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

    // Get yesterday's date
    DateTime yesterdayDate = DateTime.now().subtract(Duration(days: 1));
    String yesterdayFormattedDate =
        DateFormat('dd/MM/yyyy').format(yesterdayDate);

    // Check if the formatted date is today, yesterday, or another day
    if (formattedDate == currentFormattedDate) {
      return 'Today';
    } else if (formattedDate == yesterdayFormattedDate) {
      return 'Yesterday';
    } else {
      return formattedDate;
    }
  }

  Future<List<NotificationItem>> fetchNotificationItems() async {
    List<NotificationItem> notificationItems = [];

    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Notifications').get();

      querySnapshot.docs.forEach((doc) {
        Timestamp timestamp = doc['created_at'];
        Map<String, String> timestamp_format = formatDateAndTime(timestamp);
        print(timestamp_format['date']!);
        String date = formatDate(timestamp);
        String heading = doc['title'];
        String content = doc['message'];
        String time = timestamp_format['time']!;

        NotificationItem item = NotificationItem(
          date: date.toString(),
          heading: heading.toString(),
          content: content.toString(),
          icon: Icons.circle,
          time: time.toString(),
          timestamp: timestamp,
        );
        notificationItems.add(item);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching notifications: $error');
      // Handle error gracefully
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    return notificationItems;
  }

  DateTime? _selectedDate; // Store the selected date

  // Function to show date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  List<NotificationItem> filteredNotifications() {
    if (_selectedDate == null) {
      // If no date is selected, return all notifications
      return notificationItems;
    } else {
      // Filter notifications by the selected date
      return notificationItems.where((item) {
        // Assuming item.date is a String in 'yyyy-MM-dd' format
        // Convert item.date to DateTime for comparison
        DateTime itemDate = DateTime.parse(item.date);
        // Compare itemDate with _selectedDate
        return itemDate.year == _selectedDate!.year &&
            itemDate.month == _selectedDate!.month &&
            itemDate.day == _selectedDate!.day;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(102, 2, 79, 166),
          automaticallyImplyLeading: false,
          title: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child:
                        Icon(Icons.arrow_back, color: Colors.black, size: 25)),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Center(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show loader while loading
          : SafeArea(
              child: Container(
                color: Colors.white,
                child: notificationItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 140.0,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'No Notifications',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                letterSpacing: .5,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "We’ll let you know when there will be",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: Colors.grey),
                            ),
                            Text(
                              "something to update you",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // setState(() {
                                //   notificationItemsFiltered =
                                //       filteredNotifications();
                                // });
                                // _selectDate(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 6.0,
                                primary: Color.fromARGB(255, 255, 255, 255),
                                onPrimary: Colors.black,
                                minimumSize: Size(double.infinity, 50),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        'All Notifications',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 12.0),
                                  //   child: Icon(
                                  //     Icons.calendar_month,
                                  //     color: Color.fromARGB(255, 61, 58, 58),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: notificationItems.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (index == 0 ||
                                        notificationItems[index].date !=
                                            notificationItems[index - 1].date)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          notificationItems[index].date,
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.grey),
                                        ),
                                      ),
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      leading: Container(
                                        width:
                                            56, // Fixed width for the leading widget
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(notificationItems[index].icon),
                                          ],
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notificationItems[index].heading,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            notificationItems[index].content,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start, // Align the Row content to the top
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Time',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                notificationItems[index].time,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
