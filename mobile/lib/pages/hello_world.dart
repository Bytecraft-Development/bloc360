import 'package:flutter/material.dart';
import 'package:frontend/config/environment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'cui_input.dart';
import 'expenses.dart';

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
                // Display the text received in the response from the server
                return Center(child: Text(snapshot.data.toString()));
              }
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to CuiInputPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CuiInputPage()),
              );
            },
            child: Text('Go to CuiInputPage'),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to ExpensePage
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _accessToken = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${EnvironmentConfig.API_URL}/hello'),
      headers: <String, String>{
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Return the text received in the response from the server
      return response.body;
    } else {
      // Return an error message in case the request failed
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}