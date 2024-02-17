import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static final String baseUrl = '';

  static Future<Map<String, dynamic>> get(String endpoint, String objectName) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response, objectName);
  }

  static Future<Map<String, dynamic>> post(String endpoint, String objectName, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response, objectName);
  }

  static Future<Map<String, dynamic>> put(String endpoint, String objectName, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response, objectName);
  }

  static Future<Map<String, dynamic>> delete(String endpoint, String objectName) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response, objectName);
  }

  static Map<String, dynamic> _handleResponse(http.Response response, String objectName) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load $objectName');
    }
  }
}
