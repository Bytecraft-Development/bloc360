import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HelloWorld.dart'; // Importăm pagina HelloWorld

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keycloak Login Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Keycloak Login Example'),
        ),
        body: LoginPage(),
      ),
    );
  }
}

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

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Trimite cererea pentru a obține token-ul de acces de la Keycloak
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
      // Procesează răspunsul și salvează token-ul de acces
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      _accessToken = jsonResponse['access_token'];
      String tokenType = jsonResponse['token_type'];

      // Salvează token-ul de acces într-o variabilă globală sau în shared_preferences
      print('Access Token: $tokenType $_accessToken');

      // Navighează către pagina Hello World și trimite token-ul în header-ul cererii
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HelloWorldPage(accessToken: _accessToken),
        ),
      );
    } else {
      // Tratează cazurile în care autentificarea a eșuat
      print('Failed to login: ${response.statusCode}');
    }
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