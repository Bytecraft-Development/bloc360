import 'package:flutter/material.dart';

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

  EdgeInsets getPadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      return EdgeInsets.symmetric(horizontal: 190, vertical: 24.0);
    } else {
      return EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget buildCountersSection() {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Desktop Layout
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildCheckboxTile('Apă rece', _coldWater, (value) => setState(() => _coldWater = value ?? false)),
                SizedBox(width: 130), // Distanță orizontală de 2 pixeli
                buildCheckboxTile('Apă caldă', _hotWater, (value) => setState(() => _hotWater = value ?? false)),
                SizedBox(width: 130), // Distanță orizontală de 2 pixeli
                buildCheckboxTile('Gaz', _gas, (value) => setState(() => _gas = value ?? false)),
                SizedBox(width: 130), // Distanță orizontală de 2 pixeli
                buildCheckboxTile('Încălzire', _heating, (value) => setState(() => _heating = value ?? false)),
              ],
            );
          } else {
            // Mobile Layout - 2x2 grid
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildCheckboxTile('Apă rece', _coldWater, (value) => setState(() => _coldWater = value ?? false)),
                    ),
                    SizedBox(width: 2), // Distanță orizontală de 2 pixeli
                    Expanded(
                      child: buildCheckboxTile('Apă caldă', _hotWater, (value) => setState(() => _hotWater = value ?? false)),
                    ),
                  ],
                ),
                SizedBox(height: 2), // Distanță verticală de 2 pixeli
                Row(
                  children: [
                    Expanded(
                      child: buildCheckboxTile('Gaz', _gas, (value) => setState(() => _gas = value ?? false)),
                    ),
                    SizedBox(width: 2), // Distanță orizontală de 2 pixeli
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

                  // Input Fields (Name and Register Number)
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('Denumire legală', _nameController, width: 400), // Lățime ajustabilă
                      ),
                      SizedBox(width: 8), // Distanță orizontală de 2 pixeli
                      Expanded(
                        child: buildTextField('Nr. registru comerț', _registerComertController, width: 400), // Lățime ajustabilă
                      ),
                    ],
                  ),
                  SizedBox(height: 32), // Distanță verticală

                  // Input Fields (Address and Bank Name)
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('Adresă', _addressController, width: 400), // Lățime ajustabilă
                      ),
                      SizedBox(width: 8), // Distanță orizontală de 2 pixeli
                      Expanded(
                        child: buildTextField('Banca', _bankNameController, width: 400), // Lățime ajustabilă
                      ),
                    ],
                  ),
                  SizedBox(height: 32), // Distanță verticală

                  // Input Fields (CUI and IBAN)
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField('CUI', _cuiController, width: 400), // Lățime ajustabilă
                      ),
                      SizedBox(width: 8), // Distanță orizontală de 2 pixeli
                      Expanded(
                        child: buildTextField('IBAN', _bankAccountController, width: 400), // Lățime ajustabilă
                      ),
                    ],
                  ),
                  SizedBox(height: 32), // Distanță verticală

                  // Title for Counters Section
                  Text(
                    'Contoare',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Counters Section with new implementation
                  buildCountersSection(),

                  SizedBox(height: 32), // Distanță verticală

                  // Invoice Date Section Title
                  Text(
                    'Ziua Emiterii Facturilor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Invoice Date Input
                  buildTextField('Introduceți ziua', _indexDateController, width: 350), // Lățime ajustabilă
                  SizedBox(height: 32), // Distanță verticală

                  // Next Step Button
                  Align(
                    alignment: MediaQuery.of(context).size.width > 600
                        ? Alignment.centerRight // Aliniere la dreapta pe desktop
                        : Alignment.center,      // Centrat pe mobil
                    child: Padding(
                      padding: MediaQuery.of(context).size.width > 600
                          ? const EdgeInsets.only(right: 370) // Padding aplicat doar pe desktop
                          : EdgeInsets.zero, // Fără padding pe mobil // Optional: padding dreapta pe desktop
                      child: ElevatedButton(
                        onPressed: () {
                          // Call create association function
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 45), // Lățime buton
                          backgroundColor: Colors.blue[900], // Fundal albastru închis
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // Border radius mai mic
                          ),
                        ),
                        child: Text('Pasul următor', style: TextStyle(color: Colors.white)), // Asigură-te că textul este vizibil
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
          width: width, // Lățimea poate fi ajustată aici
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
      width: 200, // Lățime fixă pentru checkbox-uri
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
