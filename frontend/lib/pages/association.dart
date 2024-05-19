import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;


class AssociationView extends StatefulWidget {
  @override
  _AssociationViewState createState() => _AssociationViewState();
}

class _AssociationViewState extends State<AssociationView> {
  @override
  void initState() {
    super.initState();
    _checkRoleAndRedirect();
  }

  Future<void> _checkRoleAndRedirect() async {
    String? accessToken = html.window.localStorage['access_token'];
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
      if (redirectUrl.contains("admin/dashboard")) {
        context.go('/hello_world');
      } else {
        context.go('/cui_input');
      }
    } else {
      throw Exception('Failed to redirect based on role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Association View'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // Afișează un indicator de încărcare până la redirecționare
      ),
    );
  }
}