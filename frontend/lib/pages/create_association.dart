import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/pages/add_block.dart'; // Asigură-te că ai importat corect pagina AddBlockPage

class CreateAssociationPage extends StatefulWidget {
  @override
  _CreateAssociationPageState createState() => _CreateAssociationPageState();
}

class _CreateAssociationPageState extends State<CreateAssociationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cuiController = TextEditingController();
  final _registerComertController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _coldWaterController = TextEditingController();
  final _hotWaterController = TextEditingController();
  final _gasController = TextEditingController();
  final _heatingController = TextEditingController();
  final _indexDateController = TextEditingController();

  bool _hasBlocks = false;
  bool _hasHouses = false;

  Future<void> _saveAssociationId(int associationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('association_id', associationId);
  }

  Future<void> _createAssociation() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (_formKey.currentState?.validate() ?? false) {
      final indexDate = _indexDateController.text;

      // Parse date in format dd.MM.yyyy to yyyy-MM-dd
      DateTime? date;
      try {
        final parts = indexDate.split('.');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          date = DateTime(year, month, day);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid date format')),
        );
        return;
      }

      final formattedIndexDate = date != null
          ? '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
          : '';

      final response = await http.post(
        Uri.parse('http://localhost:7080/createAssociation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'address': _addressController.text,
          'cui': _cuiController.text,
          'registerComert': _registerComertController.text,
          'bankAccount': _bankAccountController.text,
          'bankName': _bankNameController.text,
          'coldWater': _coldWaterController.text == 'true',
          'hotWater': _hotWaterController.text == 'true',
          'gas': _gasController.text == 'true',
          'heating': _heatingController.text == 'true',
          'indexDate': formattedIndexDate,
          'hasBlocks': _hasBlocks,
          'hasHouses': _hasHouses,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final associationId = responseData['associationId'];

        if (associationId != null && associationId is int) {
          // Salvează associationId în SharedPreferences
          await _saveAssociationId(associationId);

          // Navighează la pagina AddBlockPage cu associationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBlockPage(associationId: associationId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to retrieve association ID')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create association')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Association')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Association Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _cuiController,
                decoration: InputDecoration(labelText: 'CUI'),
              ),
              TextFormField(
                controller: _registerComertController,
                decoration: InputDecoration(labelText: 'Register Comert'),
              ),
              TextFormField(
                controller: _bankAccountController,
                decoration: InputDecoration(labelText: 'Bank Account'),
              ),
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(labelText: 'Bank Name'),
              ),
              TextFormField(
                controller: _coldWaterController,
                decoration: InputDecoration(labelText: 'Cold Water (true/false)'),
              ),
              TextFormField(
                controller: _hotWaterController,
                decoration: InputDecoration(labelText: 'Hot Water (true/false)'),
              ),
              TextFormField(
                controller: _gasController,
                decoration: InputDecoration(labelText: 'Gas (true/false)'),
              ),
              TextFormField(
                controller: _heatingController,
                decoration: InputDecoration(labelText: 'Heating (true/false)'),
              ),
              TextFormField(
                controller: _indexDateController,
                decoration: InputDecoration(labelText: 'Index Date (dd.MM.yyyy)'),
              ),
              CheckboxListTile(
                title: Text('Has Blocks'),
                value: _hasBlocks,
                onChanged: (bool? value) {
                  setState(() {
                    _hasBlocks = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Has Houses'),
                value: _hasHouses,
                onChanged: (bool? value) {
                  setState(() {
                    _hasHouses = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createAssociation,
                child: Text('Create Association'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddBlockPage extends StatefulWidget {
  final int associationId;

  AddBlockPage({required this.associationId});

  @override
  _AddBlockPageState createState() => _AddBlockPageState();
}

class _AddBlockPageState extends State<AddBlockPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _nameControllers = [];
  final List<Widget> _blockFields = [];

  @override
  void initState() {
    super.initState();
    _addBlockField(); // Adaugă un câmp de bloc inițial
  }

  void _addBlockField() {
    final controller = TextEditingController();
    _nameControllers.add(controller);
    setState(() {
      _blockFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Block Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
        ),
      );
    });
  }

  Future<void> _addBlocks() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (_formKey.currentState?.validate() ?? false) {
      final blockNames = _nameControllers.map((controller) => {'name': controller.text}).toList();
      final jsonBody = jsonEncode(blockNames);
      print('JSON Body: $jsonBody');

      final response = await http.post(
        Uri.parse('http://localhost:7080/addBlocks?associationId=${widget.associationId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(blockNames),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blocks added successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add blocks')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blocks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._blockFields,
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBlockField,
                child: Text('Add Another Block'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBlocks,
                child: Text('Add Blocks'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}