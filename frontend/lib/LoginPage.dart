import 'dart:convert';
import 'dart:html' as html; // Importă biblioteca 'dart:html' pentru a accesa window.localStorage
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HelloWorld.dart';
import 'RegistrationPage.dart'

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _keycloakTokenUrl =
      'https://bloc360.live:8443/realms/bloc360/protocol/openid-connect/token';
  final String _clientId = 'bloc360token';

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadTokenFromStorage();
  }

  Future<void> _loadTokenFromStorage() async {
    // Folosește window.localStorage pentru a citi token-ul de acces salvat
    _accessToken = html.window.localStorage['access_token'];
    if (_accessToken != null) {
      _navigateToHelloWorldPage();
    }
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(_keycloakTokenUrl),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'client_id': _clientId,
        'username': username,
        'password': password,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      _accessToken = jsonResponse['access_token'];

      // Salvează token-ul de acces în window.localStorage
      html.window.localStorage['access_token'] = _accessToken!;

      _navigateToHelloWorldPage();
    } else {
      print('Failed to login: ${response.statusCode}');
    }
  }
  void _navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  Future<void> _navigateToHelloWorldPage() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HelloWorldPage(accessToken: _accessToken),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}