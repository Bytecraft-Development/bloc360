import 'dart:convert';
import 'package:frontend/config/environment.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class TokenUtils {
  Future<String?> refreshToken(String refreshToken) async {
    final url = Uri.parse(EnvironmentConfig.KEYCLOAK_LOGIN_URL);
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'client_id': 'bloc360google',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access_token'];
        final refreshToken = responseData['refresh_token'];

        html.window.localStorage['access_token'] = accessToken;
        html.window.localStorage['refresh_token'] = refreshToken;

        return accessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> isTokenValid(String token) async {
    final url = Uri.parse('${EnvironmentConfig.API_URL}/validate');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Parse the response body as a boolean
        return jsonDecode(response.body) as bool;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
