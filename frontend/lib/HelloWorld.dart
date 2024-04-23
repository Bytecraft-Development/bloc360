import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HelloWorldPage extends StatelessWidget {
  final String? accessToken;

  const HelloWorldPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HelloWorld Page'),
      ),
      body: FutureBuilder(
        future: _fetchHelloWorldData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('Hello, World!'));
          }
        },
      ),
    );
  }

  Future<void> _fetchHelloWorldData() async {
    final response = await http.get(
      Uri.parse('https://bloc360.live:8080/hello'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      // Procesează răspunsul de la server
      print('Response from server: ${response.body}');
    } else {
      // Tratează cazurile în care cererea a eșuat
      print('Failed to fetch data: ${response.statusCode}');
    }
  }
}