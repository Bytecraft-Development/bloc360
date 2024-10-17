import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStairsPage extends StatefulWidget {
  final String blockId;

  const AddStairsPage({Key? key, required this.blockId}) : super(key: key);

  @override
  _AddStairsPageState createState() => _AddStairsPageState();
}

class _AddStairsPageState extends State<AddStairsPage> {
  TextEditingController stairNameController = TextEditingController();

  // Funcție pentru a trimite datele către backend
  Future<void> addStairToBlock(String stairName) async {
    final String baseUrl = "http://localhost:7080"; // Modifică URL-ul conform API-ului tău
    var url = Uri.parse('$baseUrl/addStair?blockId=${widget.blockId}');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode([
        {"name": stairName},
      ]),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stair added successfully!")),
      );
      stairNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add stair.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Stairs to Block"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Block ID: ${widget.blockId}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: stairNameController,
              decoration: InputDecoration(labelText: 'Stair Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (stairNameController.text.isNotEmpty) {
                  addStairToBlock(stairNameController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a stair name")),
                  );
                }
              },
              child: Text("Add Stair"),
            ),
          ],
        ),
      ),
    );
  }
}