import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/environment.dart';
import 'add_blocks_and_stairs.dart';

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

  EdgeInsets getPadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      return EdgeInsets.symmetric(horizontal: 190, vertical: 24.0);
    } else {
      return EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0);
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _createAssociation() async {
    if (_formKey.currentState!.validate()) {
      final token = await _getToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication token is missing.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${EnvironmentConfig.API_URL}/createAssociation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'address': _addressController.text,
          'cui': _cuiController.text,
          'registerComert': _registerComertController.text,
          'bankAccount': _bankAccountController.text,
          'bankName': _bankNameController.text,
          'indexDate': _indexDateController.text,
          'coldWater': _coldWater,
          'hotWater': _hotWater,
          'gas': _gas,
          'heating': _heating,
          'hasBlocks': _hasBlocks,
          'hasHouses': _hasHouses,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final associationId = responseBody['associationId'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBlocksAndStairsPage(associationId: associationId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la crearea asociației.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget buildCountersSection() {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildCheckboxTile('Apă rece', _coldWater, (value) => setState(() => _coldWater = value ?? false)),
                SizedBox(width: 130),
                buildCheckboxTile('Apă caldă', _hotWater, (value) => setState(() => _hotWater = value ?? false)),
                SizedBox(width: 130),
                buildCheckboxTile('Gaz', _gas, (value) => setState(() => _gas = value ?? false)),
                SizedBox(width: 130),
                buildCheckboxTile('Încălzire', _heating, (value) => setState(() => _heating = value ?? false)),
              ],
            );
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildCheckboxTile('Apă rece', _coldWater, (value) => setState(() => _coldWater = value ?? false)),
                    ),
                    SizedBox(width: 2),
                    Expanded(
                      child: buildCheckboxTile('Apă caldă', _hotWater, (value) => setState(() => _hotWater = value ?? false)),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: buildCheckboxTile('Gaz', _gas, (value) => setState(() => _gas = value ?? false)),
                    ),
                    SizedBox(width: 2),
                    Expanded(
                      child: buildCheckboxTile('Încălzire', _heating, (value) => setState(() => _heating = value ?? false)),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: getPadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  Text(
                    'Crează Asociație',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('Denumire legală', _nameController, width: 400),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: buildTextField('Nr. registru comerț', _registerComertController, width: 400),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('Adresă', _addressController, width: 400),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: buildTextField('Banca', _bankNameController, width: 400),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('CUI', _cuiController, width: 400),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: buildTextField('IBAN', _bankAccountController, width: 400),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Contoare',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 16),
                  buildCountersSection(),
                  SizedBox(height: 32),
                  Text(
                    'Ziua Emiterii Facturilor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 16),
                  buildTextField('Introduceți ziua', _indexDateController, width: 350),
                  SizedBox(height: 32),
                  Align(
                    alignment: MediaQuery.of(context).size.width > 600
                        ? Alignment.centerRight
                        : Alignment.center,
                    child: Padding(
                      padding: MediaQuery.of(context).size.width > 600
                          ? const EdgeInsets.only(right: 370)
                          : EdgeInsets.zero,
                      child: ElevatedButton(
                        onPressed: _createAssociation,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 45),
                          backgroundColor: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text('Pasul următor', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller, {double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyle(fontSize: 14, color: Colors.black)),
        SizedBox(height: 4),
        Container(
          width: width,
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
          ),
        ),
      ],
    );
  }

  Widget buildCheckboxTile(String title, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      width: 200,
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: Color(0xFF616161)),
        ),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        dense: true,
      ),
    );
  }
}