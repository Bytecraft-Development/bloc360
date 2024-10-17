import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssociationInformationPage extends StatefulWidget {
  final Map<String, dynamic> associationData;

  const AssociationInformationPage({Key? key, required this.associationData}) : super(key: key);

  @override
  _AssociationInformationPageState createState() => _AssociationInformationPageState();
}

class _AssociationInformationPageState extends State<AssociationInformationPage> {
  String? selectedBlockId;
  List<TextEditingController> stairControllers = [TextEditingController()];
  bool isLoading = false;

  // Funcția pentru adăugarea scărilor într-un bloc
  Future<void> addStairsToBlock(String blockId) async {
    const API_URL = String.fromEnvironment('API_URL');
    final String baseUrl = API_URL;
    var url = Uri.parse('$baseUrl/addStair?blockId=$blockId');
    setState(() {
      isLoading = true;
    });

    List<Map<String, String>> stairsData = stairControllers
        .map((controller) => {"name": controller.text})
        .toList();

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(stairsData),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stairs added successfully!")),
      );
      stairControllers.forEach((controller) => controller.clear());
      setState(() {
        widget.associationData['blocks'].forEach((block) {
          if (block['id'].toString() == blockId) {
            block['stairs'] ??= [];
            block['stairs'].addAll(stairsData);
          }
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add stairs.")),
      );
    }
  }


  void addNewStairField() {
    setState(() {
      stairControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    stairControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Association Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Association Info',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Name: ${widget.associationData['name']}'),
            Text('Address: ${widget.associationData['address']}'),
            SizedBox(height: 16),

            // Blocuri din asociatie
            if (widget.associationData['blocks'] != null &&
                widget.associationData['blocks'].isNotEmpty) ...[
              Text('Blocks:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),

              // Dropdown pentru selectarea blocului
              DropdownButton<String>(
                hint: Text("Select Block"),
                value: selectedBlockId,
                items: widget.associationData['blocks']
                    .map<DropdownMenuItem<String>>((block) {
                  return DropdownMenuItem<String>(
                    value: block['id'].toString(),
                    child: Text(block['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBlockId = value;
                  });
                },
              ),

              // Afișarea scărilor existente în blocul selectat
              if (selectedBlockId != null) ...[
                SizedBox(height: 16),
                Text("Existing Stairs for Block:"),
                SizedBox(height: 8),
                _buildStairsList(),

                // Formularul pentru a adăuga scări noi
                SizedBox(height: 16),
                Text("Add Stairs:"),
                Column(
                  children: List.generate(stairControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: stairControllers[index],
                        decoration: InputDecoration(labelText: 'Stair ${index + 1} Name'),
                      ),
                    );
                  }),
                ),

                // Buton pentru a adăuga un nou câmp de input pentru scări
                TextButton(
                  onPressed: addNewStairField,
                  child: Text("Add another stair"),
                ),

                SizedBox(height: 16),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    bool hasEmptyField = stairControllers.any((controller) => controller.text.isEmpty);
                    if (!hasEmptyField) {
                      addStairsToBlock(selectedBlockId!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all stair names")),
                      );
                    }
                  },
                  child: Text("Add Stairs"),
                ),
              ],
            ] else
              Text("No blocks available."),
          ],
        ),
      ),
    );
  }

  // Funcție pentru a afișa lista scărilor existente pentru blocul selectat
  Widget _buildStairsList() {
    var block = widget.associationData['blocks'].firstWhere((block) => block['id'].toString() == selectedBlockId);
    var stairs = block['stairs'] ?? [];

    if (stairs.isEmpty) {
      return Text("No stairs available for this block.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stairs.map<Widget>((stair) {
        return Text("- ${stair['name']}");
      }).toList(),
    );
  }
}
