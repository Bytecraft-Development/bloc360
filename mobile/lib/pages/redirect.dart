import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RedirectView extends StatefulWidget {
  @override
  _RedirectViewState createState() => _RedirectViewState();

}

class _RedirectViewState extends State<RedirectView> {
  @override
  void initState() {
    super.initState();
    _checkRoleAndRedirect();
  }

  Future<void> _checkRoleAndRedirect() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    const API_URL = String.fromEnvironment('API_URL');
    final String baseUrl = API_URL;

    if (accessToken == null) {
      throw Exception('No access token found, please log in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/redirectByRole'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final redirectUrl = response.body;
      context.go(redirectUrl);
    } else {
      throw Exception('Failed to redirect based on role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redirect View'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}