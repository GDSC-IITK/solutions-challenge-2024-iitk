import 'package:flutter/material.dart';

class Page7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: const Color.fromARGB(250, 67, 121, 184),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create a Post",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              "continue to leave feedback",
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(170, 255, 255, 255),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // add image
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: Text(
                "Add Images",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: Color.fromARGB(130, 2, 79, 166),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                //  add location
              },
              icon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ),
              label: Row(
                children: [
                  Text(
                    "Add Location",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(double.infinity, 0),
                backgroundColor: Color.fromARGB(252, 132, 173, 219),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                //  write text
              },
              icon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              label: Row(
                children: [
                  Text(
                    "Continue to Write Text",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(double.infinity, 0),
                backgroundColor: Color.fromARGB(252, 132, 173, 219),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                //  select number of people served
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      "No. of people that were served",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(double.infinity, 0),
                backgroundColor: Color.fromARGB(252, 132, 173, 219),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
