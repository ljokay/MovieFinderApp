import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Authentication {
  final String apiKey;
  Authentication(this.apiKey);

  Future<String?> createRequestToken() async {
    final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/authentication/token/new?api_key=$apiKey'
    ));

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['request_token'];
    }
    else {
      throw Exception('Failed to create request token');
    }
  }

  Future<bool> validateRequestTokenWithLogin(String username, String password, String requestToken) async {
    final response = await http.post(
      Uri.parse('https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'request_token': requestToken,
      }),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'];
    }
    else {
      throw Exception('Error occured with login');
    }
  }

  Future<String?> createSession(String requestToken) async {
    final response = await http.post(
      Uri.parse('https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'request_token': requestToken}),
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['session_id'];
    }
    else {
      throw Exception('Session Create Failed');
    }
  }
}