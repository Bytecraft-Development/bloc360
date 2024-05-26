import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:jose/jose.dart';

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
    final jwksUri = Uri.parse(
        'https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/certs');

    try {
      // Fetch the JWKS (JSON Web Key Set)
      final jwksResponse = await http.get(jwksUri);
      if (jwksResponse.statusCode != 200) {
        return false;
      }
      final jwksData = jsonDecode(jwksResponse.body);

      // Decode the token without verification to extract the header
      final parts = token.split('.');
      if (parts.length != 3) {
        return false;
      }
      final header = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[0]))));

      // Find the key with the matching key ID (kid)
      final keyId = header['kid'];
      final key = jwksData['keys']
          .firstWhere((k) => k['kid'] == keyId, orElse: () => null);
      if (key == null) {
        return false;
      }

      // Construct the public key from the JWK data
      final publicKey = JsonWebKey.fromJson(key);

      // Verify the token signature
      final jwt = JWT.verify(token, publicKey as JWTKey);

      // Optionally, you can add more checks here, e.g., checking the token expiration, issuer, audience, etc.
      return true;
    } catch (e) {
      return false;
    }
  }
}
