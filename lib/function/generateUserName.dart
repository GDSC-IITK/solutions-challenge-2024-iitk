import 'dart:math';

String generateUsername(String email, String name) {
  // Remove any special characters from the email
  String sanitizedEmail = email.replaceAll(RegExp(r'[^\w\s]'), '');
  // Split the name into parts
  List<String> nameParts = name.split(' ');

  // Take the first part of the name as the username prefix
  String usernamePrefix = nameParts.isNotEmpty
      ? nameParts[0].substring(0, min(nameParts[0].length, 3))
      : '';

  // Combine the username prefix with parts of the email
  String emailFirst = sanitizedEmail.split('@').first;
  String username =
      '$usernamePrefix${emailFirst.substring(0, int.parse(Random().nextInt(3).toString()) + 1)}';

  // Ensure the username is not too long
  if (username.length > 15) {
    username = username.substring(0, 15);
  }

  // Add a random suffix to ensure uniqueness
  String randomSuffix = Random().nextInt(1000).toString();
  username += randomSuffix;

  return username;
}
