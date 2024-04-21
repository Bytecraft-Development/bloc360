import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'CuiInputPage.dart'; // Importăm pagina CuiInputPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data = ""; // Stores the fetched data
  bool isLoading = false; // Flag to indicate loading state

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    final response =
    await http.get(Uri.parse('https://bloc360.live:8080/hello'));

    if (response.statusCode == 200) {
      setState(() {
        data = response.body;
        isLoading = false; // Hide loading indicator after successful fetch //
      });
    } else {
      // Handle error scenario (e.g., display error message) test
      print('Error fetching data: ${response.statusCode}');
      setState(() {
        isLoading = false; // Hide loading indicator even on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator() // Show spinner while loading
                : Text(data),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CuiInputPage()), // Navigăm către CuiInputPage
              );
            },
            child: const Text('Introdu CUI-ul'), // Textul butonului
          ),
        ],
      ),
    );
  }
}
