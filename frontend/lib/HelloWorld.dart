import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'CuiInputPage.dart';
import 'ExpensePage.dart';

class HelloWorldPage extends StatelessWidget {
  final String? accessToken;

  const HelloWorldPage({Key? key, required this.accessToken}) : super(key: key);

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
    final response = await http.get(
      Uri.parse('https://bloc360.live:8080/hello'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
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