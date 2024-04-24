import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CuiInputPage extends StatefulWidget {
  @override
  _CuiInputPageState createState() => _CuiInputPageState();
}

class _CuiInputPageState extends State<CuiInputPage> {
  TextEditingController _cuiController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  Future<void> _sendCuiToBackend() async {
    String cui = _cuiController.text.trim();
    if (cui.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('https://bloc360.live:8080/createCompany'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          // Trimite doar valoarea CUI direct
          body: cui,
        );
        print('Request body: $requestBody');

        if (response.statusCode == 200) {
          setState(() {
            _isLoading = false;
            _message = 'Company info details are OK';
          });
        } else {
          print('Failed to create association: ${response.statusCode}');
          setState(() {
            _isLoading = false;
            _message = 'Failed to create association: ${response.statusCode}';
          });
        }
      } catch (e) {
        print('Exception creating association: $e');
        setState(() {
          _isLoading = false;
          _message = 'Exception creating association: $e';
        });
      }
    } else {
      setState(() {
        _message = 'CUI is empty';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduceți CUI-ul'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cuiController,
              decoration: InputDecoration(
                labelText: 'CUI',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendCuiToBackend,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Trimiteți CUI-ul'),
            ),
            SizedBox(height: 8.0),
            _message.isNotEmpty
                ? Text(
              _message,
              style: TextStyle(
                color:
                _message.contains('OK') ? Colors.green : Colors.red,
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}