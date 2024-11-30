import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/environment.dart';

class AddBlocksAndStairsPage extends StatefulWidget {
  final int associationId;

  const AddBlocksAndStairsPage({Key? key, required this.associationId})
      : super(key: key);

  @override
  _AddBlocksAndStairsPageState createState() => _AddBlocksAndStairsPageState();
}

class _AddBlocksAndStairsPageState extends State<AddBlocksAndStairsPage> {
  final _blockNameController = TextEditingController();
  final _stairNameController = TextEditingController();
  final List<Map<String, dynamic>> _blocks = [];
  final List<String> _stairs = [];
  String? _selectedBlockId;
  bool _isLoading = false;
  bool _blocksSubmitted = false;

  Future<void> _loadBlocks() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final response = await http.get(
      Uri.parse('${EnvironmentConfig.API_URL}/blocks?associationId=${widget.associationId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      setState(() {
        _blocks.clear();
        _blocks.addAll(responseBody.map((block) {
          return {
            'id': block['id'],
            'name': block['name'],
            'stairs': block['stairs'] ?? [],
          };
        }).toList());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eșec la încărcarea blocurilor')),
      );
    }
  }

  void _addBlock() {
    if (_blockNameController.text.isNotEmpty) {
      setState(() {
        _blocks.add({'name': _blockNameController.text, 'id': null, 'stairs': []});
        _blockNameController.clear();
      });
    }
  }

  Future<void> _submitBlocks() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('${EnvironmentConfig.API_URL}/addBlocks?associationId=${widget.associationId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(
          _blocks.map((block) => {'name': block['name']}).toList()),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blocuri adăugate cu succes')),
      );
      setState(() {
        _blocksSubmitted = true;
      });

      await _loadBlocks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eșec la adăugarea blocurilor')),
      );
    }
  }

  Future<void> _addStair() async {
    if (_selectedBlockId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Te rog selectează un bloc')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    final response = await http.post(
      Uri.parse('${EnvironmentConfig.API_URL}/addStair?blockId=$_selectedBlockId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(_stairs.map((name) => {'name': name}).toList()),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scările adăugate cu succes')),
      );
      setState(() {
        _stairs.clear();
      });

      await _loadBlocks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eșec la adăugarea scărilor')),
      );
    }
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyle(fontSize: 14, color: Colors.black)),
        SizedBox(height: 4),
        Container(
          width: width ?? 200,
          decoration: BoxDecoration(
            color: Color(0xFFECF4FF),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFECF4FF),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBlocks();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width > 600 ? 150 : 70, vertical: 50),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Adaugă Blocuri și Scări',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 60),
                      Text(
                        '1. Adaugă Blocuri',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: buildTextField('Nume Bloc', _blockNameController),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _addBlock,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      for (var block in _blocks)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Text(block['name']),
                          ),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitBlocks,
                        child: Text('Trimite Blocurile'),
                      ),
                      SizedBox(height: 60),

                      if (_blocksSubmitted) ...[
                        Text(
                          '2. Adaugă Scările',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedBlockId,
                            items: _blocks.map((block) {
                              return DropdownMenuItem<String>(
                                value: block['id'].toString(),
                                child: Text(block['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBlockId = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Alege un bloc',
                              filled: true,
                              fillColor: Color(0xFFECF4FF),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child: buildTextField('Nume Scară', _stairNameController),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _stairs.add(_stairNameController.text);
                                    _stairNameController.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        for (var stair in _stairs)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(stair),
                            ),
                          ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addStair,
                          child: Text('Adaugă Scările'),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lista Blocuri și Scări',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 700,
                        child: ListView.builder(
                          itemCount: _blocks.length,
                          itemBuilder: (context, index) {
                            final block = _blocks[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bloc: ${block['name']}',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                for (var stair in block['stairs'])
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16, top: 4),
                                    child: Text(
                                      'Scara: ${stair['name']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                                SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}