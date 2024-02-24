import 'dart:io';

import 'package:gdsc/apiKey.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> returnReponse(String prompt) async {
  final apiKey = ApiKey.api_key_gemini;
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  print("gemini called");
  // For text-only input, use the gemini-pro model
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final content = [Content.text(prompt)];
  final response = await model.generateContent(content);
  return response.text!;
}
