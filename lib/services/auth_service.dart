import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _apiKey = 'cb6a70b74d1afd03cf90ba15bac01065'; // Replace with your actual API key
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Store the session ID
  static String? _sessionId;

  // Check if the user is authenticated
  static bool get isAuthenticated => _sessionId != null;

  // Authenticate the user
   Future<void> login(String username, String password) async {
    try {
      // Step 1: Create a request token
      final requestTokenResponse = await http.get(
        Uri.parse('$_baseUrl/authentication/token/new?api_key=$_apiKey'),
      );

      if (requestTokenResponse.statusCode == 200) {
        final requestToken = json.decode(requestTokenResponse.body)['request_token'];

        // Step 2: Validate request token with login
        final loginResponse = await http.post(
          Uri.parse('$_baseUrl/authentication/token/validate_with_login?api_key=$_apiKey'),
          headers: {'Content-Type': 'application/json;charset=utf-8'},
          body: json.encode({
            'username': username,
            'password': password,
            'request_token': requestToken,
          }),
        );

        if (loginResponse.statusCode == 200) {
          // Step 3: Create a session ID
          final sessionResponse = await http.post(
            Uri.parse('$_baseUrl/authentication/session/new?api_key=$_apiKey'),
            headers: {'Content-Type': 'application/json;charset=utf-8'},
            body: json.encode({'request_token': requestToken}),
          );

          if (sessionResponse.statusCode == 200) {
            _sessionId = json.decode(sessionResponse.body)['session_id'];
            print('token : $requestToken and session ID : $_sessionId');
          } else {
            throw Exception('Failed to create session. Status code: ${sessionResponse.statusCode}');
          }
        } else {
          throw Exception('Failed to validate request token. Status code: ${loginResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to create request token. Status code: ${requestTokenResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  // Helper method to get the current session ID
   // Fetch session ID from storage or API
  static Future<String?> getSessionId() async {
    return _sessionId; // Replace with your logic to fetch session ID
  }

  // Set session ID
  static Future<void> setSessionId(String sessionId) async {
    _sessionId = sessionId;
  }
}
