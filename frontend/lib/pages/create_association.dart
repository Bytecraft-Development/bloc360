import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/pages/add_block.dart';
import 'package:frontend/pages/add_house.dart';
import 'package:frontend/pages/add_blocks_and_houses.dart'; // Asigură-te că ai această pagină

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
  final _indexDateController = TextEditingController();

  bool _coldWater = false;
  bool _hotWater = false;
  bool _gas = false;
  bool _heating = false;
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

      const API_URL = String.fromEnvironment('API_URL');
      final String baseUrl = API_URL;
      final response = await http.post(
        Uri.parse('$baseUrl/createAssociation'),
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
          'coldWater': _coldWater,
          'hotWater': _hotWater,
          'gas': _gas,
          'heating': _heating,
          'indexDate': formattedIndexDate,
          'hasBlocks': _hasBlocks,
          'hasHouses': _hasHouses,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final associationId = responseData['associationId'];

        if (associationId != null && associationId is int) {
          await _saveAssociationId(associationId);


          if (_hasBlocks && _hasHouses) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBlocksAndHousesPage(associationId: associationId),
              ),
            );
          } else if (_hasBlocks) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBlockPage(associationId: associationId),
              ),
            );
          } else if (_hasHouses) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddHousePage(associationId: associationId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select at least one option (Blocks or Houses)')),
            );
          }
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
              SwitchListTile(
                title: Text('Cold Water'),
                value: _coldWater,
                onChanged: (bool value) {
                  setState(() {
                    _coldWater = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Hot Water'),
                value: _hotWater,
                onChanged: (bool value) {
                  setState(() {
                    _hotWater = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Gas'),
                value: _gas,
                onChanged: (bool value) {
                  setState(() {
                    _gas = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Heating'),
                value: _heating,
                onChanged: (bool value) {
                  setState(() {
                    _heating = value;
                  });
                },
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
      const API_URL = String.fromEnvironment('API_URL');
      final String baseUrl = API_URL;
      final response = await http.post(
        Uri.parse('$baseUrl/addBlocks?associationId=${widget.associationId}'),
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
class AddHousePage extends StatefulWidget {
  final int associationId;

  AddHousePage({required this.associationId});

  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _nameControllers = [];
  final List<Widget> _houseFields = [];

  @override
  void initState() {
    super.initState();
    _addHouseField(); // Adaugă un câmp de casă inițial
  }

  void _addHouseField() {
    final controller = TextEditingController();
    _nameControllers.add(controller);
    setState(() {
      _houseFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: 'House Name'),
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

  Future<void> _addHouses() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (_formKey.currentState?.validate() ?? false) {
      final houseNames = _nameControllers.map((controller) => {'name': controller.text}).toList();
      final jsonBody = jsonEncode(houseNames);
      print('JSON Body: $jsonBody');

      final response = await http.post(
        Uri.parse('https://bloc360.live:8080/addHouse?associationId=${widget.associationId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Houses added successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add houses')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Houses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._houseFields,
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addHouseField,
                child: Text('Add Another House'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addHouses,
                child: Text('Add Houses'),
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


class AddBlocksAndHousesPage extends StatefulWidget {
  final int associationId;

  AddBlocksAndHousesPage({required this.associationId});

  @override
  _AddBlocksAndHousesPageState createState() => _AddBlocksAndHousesPageState();
}

class _AddBlocksAndHousesPageState extends State<AddBlocksAndHousesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blocks and Houses')),
      body: Column(
        children: [
          Expanded(
            child: AddBlockPage(associationId: widget.associationId),
          ),
          Divider(), // Separă cele două formulare
          Expanded(
            child: AddHousePage(associationId: widget.associationId),
          ),
        ],
      ),
    );
  }
}


