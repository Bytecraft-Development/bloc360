import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'HelloWorld.dart';
import 'RegistrationPage.dart';
import 'config/environment_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadTokenFromStorage();

  }


  Future<void> _loadTokenFromStorage() async {
    _accessToken = html.window.localStorage['access_token'];
    if (_accessToken == null) {
      return;
    }
    Map<String, dynamic> decodedToken = JwtDecoder.decode(_accessToken!);
    int _expiry = decodedToken['exp'];
    if (DateTime.now().millisecondsSinceEpoch < _expiry * 1000) {
      _navigateToHelloWorldPage();
    } else {
      html.window.localStorage.remove('access_token');
    }
  }


Future<void> _login() async {
  String username = _usernameController.text;
  String password = _passwordController.text;

  final response = await http.post(
    Uri.parse(EnvironmentConfig.KEYCLOAK_LOGIN_URL),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: <String, String>{
      'client_id': EnvironmentConfig.KEYCLOAK_CLIENT_ID,
      'username': username,
      'password': password,
      'grant_type': 'password',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    _accessToken = jsonResponse['access_token'];
    html.window.localStorage['access_token'] = _accessToken!;

    _navigateToHelloWorldPage();
  } else {
    print('Failed to login: ${response.statusCode}');
  }
}

Future<void> _navigateToHelloWorldPage() async {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HelloWorldPage(accessToken: _accessToken),
    ),
  );
}

void _navigateToRegistrationPage() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RegistrationPage()),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: FractionallySizedBox(
      widthFactor: 0.5,
      heightFactor: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
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
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _navigateToRegistrationPage,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    ),
  );
}}