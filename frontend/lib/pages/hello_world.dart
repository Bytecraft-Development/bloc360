import 'package:flutter/material.dart';
import 'package:frontend/config/environment.dart';
import 'package:http/http.dart' as http;

import 'cui_input.dart';
import 'expenses.dart';
import 'dart:html' as html;

class HelloWorldPage extends StatelessWidget {


  const HelloWorldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HelloWorld Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: _fetchHelloWorldData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Afișează textul primit în răspunsul de la server
                return Center(child: Text(snapshot.data.toString()));
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navighează către pagina CuiInputPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CuiInputPage()),
              );
            },
            child: Text('Go to CuiInputPage'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navighează către pagina ExpensePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpensePage()),
              );
            },
            child: Text('Go to ExpensePage'),
          ),
        ],
      ),
    );
  }



  Future<String> _fetchHelloWorldData() async {
    var _accessToken = html.window.localStorage['access_token'];

    final response = await http.get(

        Uri.parse('${EnvironmentConfig.API_URL}/hello'),
      headers: <String, String>{
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Returnează textul primit în răspunsul de la server
      return response.body;
    } else {
      // Returnează un mesaj de eroare în cazul eșuării cererii
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}