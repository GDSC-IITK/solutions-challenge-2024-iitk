import 'dart:math';

String generateUsername(String email, String name) {
  // Remove any special characters from the email
  String sanitizedEmail = email.replaceAll(RegExp(r'[^\w\s]'), '');

  // Split the name into parts
  List<String> nameParts = name.split(' ');

  // Take the first part of the name as the username prefix
  String usernamePrefix = nameParts.isNotEmpty ? nameParts[0] : '';

  // Combine the username prefix with parts of the email
  String username = '$usernamePrefix${sanitizedEmail.substring(0, min(sanitizedEmail.length, 10))}';

  // Add a random suffix to ensure uniqueness
  String randomSuffix = Random().nextInt(10000).toString();
  username += randomSuffix;

  return username;
}