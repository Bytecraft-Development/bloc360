import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class TokenUtils {
  Future<String?> refreshToken(String refreshToken) async {
    final url = Uri.parse(
        'https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/token');
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
    final url = Uri.parse(
        'https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/token/introspect');
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final body = {
      'client_id': 'bloc360app',
      'client_secret': 'NDuA5WLHJ181L6ecUTKyxOMhOZrhtAmX',
      'grant_type' : 'client_credentials',
      'token': token,
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['active'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
