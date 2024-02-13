import 'package:flutter/material.dart';

class NotificationItem {
  final String date;
  final String heading;
  final String content;
  final IconData icon;
  final String time;

  NotificationItem({
    required this.date,
    required this.heading,
    required this.content,
    required this.icon,
    required this.time,
  });
}

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      date: 'Today',
      heading: 'Donation completed, make a valuable review',
      content:
          'Lorem ipsum dolor sit amet. Et architecto sequi sed aperiam autem ea consequuntur vero ut omnis sint qui voluptate quidem in deserunt recusandae.',
      icon: Icons.event,
      time: 'At 05:57 Pm',
    ),
    NotificationItem(
      date: 'Today',
      heading: 'Your Donation is cancelled',
      content:
          'Lorem ipsum dolor sit amet. Et architecto sequi sed aperiam autem ea consequuntur vero ut omnis sint qui voluptate quidem in deserunt recusandae.',
      icon: Icons.,
      time: 'At 05:57 Pm',
    ),
    NotificationItem(
      date: 'Yesterday',
      heading: 'Volunteers are ready',
      content:
          'Lorem ipsum dolor sit amet. Et architecto sequi sed aperiam autem ea consequuntur vero ut omnis sint qui voluptate quidem in deserunt recusandae.',
      icon: Icons.event,
      time: 'At 05:57 Pm',
    ),
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(102, 2, 79, 166),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
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
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: notifications.isEmpty
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {},
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Icon(
                                Icons.calendar_month,
                                color: Color.fromARGB(255, 61, 58, 58),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0 ||
                                  notifications[index].date !=
                                      notifications[index - 1].date)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    notifications[index].date,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                                leading: Container(
                                  width:
                                      56, // Fixed width for the leading widget
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(notifications[index].icon),
                                    ],
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notifications[index].heading,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      notifications[index].content,
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
                                          notifications[index].time,
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
