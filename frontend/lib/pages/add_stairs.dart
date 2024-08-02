import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AddStairsPage extends StatefulWidget {
  final int blockId;

  AddStairsPage({required this.blockId});

  @override
  _AddStairsPageState createState() => _AddStairsPageState();
}

class _AddStairsPageState extends State<AddStairsPage> {
  final List<TextEditingController> _stairControllers = [];
  final int _initialStairsCount = 1;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _initialStairsCount; i++) {
      _stairControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {

    for (var controller in _stairControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addStair() {
    setState(() {
      _stairControllers.add(TextEditingController());
    });
  }

  void _removeStair(int index) {
    setState(() {
      _stairControllers.removeAt(index);
    });
  }

  Future<void> _submitStairs() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');


    final stairs = _stairControllers.map((controller) {
      return {
        'name': controller.text,
      };
    }).toList();


    final jsonBody = jsonEncode(stairs);
    print('JSON Body: $jsonBody');

    final response = await http.post(
      Uri.parse('http://localhost:7080/addStair?blockId=${widget.blockId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stairs added successfully')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add stairs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Stairs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _stairControllers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextField(
                      controller: _stairControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Stair ${index + 1}',
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _removeStair(index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStair,
              child: Text('Add Another Stair'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitStairs,
              child: Text('Submit Stairs'),
            ),
          ],
        ),
      ),
    );
  }
}