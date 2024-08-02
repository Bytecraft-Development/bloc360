import 'package:flutter/material.dart';
import 'package:frontend/pages/add_stairs.dart';  // Asigură-te că calea este corectă
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BlockListPage extends StatefulWidget {
  @override
  _BlockListPageState createState() => _BlockListPageState();
}

class _BlockListPageState extends State<BlockListPage> {
  List<Map<String, dynamic>> _blocks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBlocks();
  }

  Future<void> _fetchBlocks() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final associationId = prefs.getInt('association_id');

    if (associationId == null) {
      // Manejează cazul în care associationId este null
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Association ID is missing')),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('http://localhost:7080/blocks?associationId=$associationId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    print('Response body: ${response.body}'); // Adaugă această linie pentru debugging

    if (response.statusCode == 200) {
      try {
        final responseData = jsonDecode(response.body);
        setState(() {
          _blocks = List<Map<String, dynamic>>.from(responseData);
          _isLoading = false;
        });
      } catch (e) {
        print('Error decoding JSON: $e'); // Adaugă această linie pentru debugging
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decode response')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load blocks')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Block')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _blocks.length,
        itemBuilder: (context, index) {
          final block = _blocks[index];
          return ListTile(
            title: Text(block['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStairsPage(blockId: block['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}