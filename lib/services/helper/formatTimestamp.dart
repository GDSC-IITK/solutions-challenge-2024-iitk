import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
