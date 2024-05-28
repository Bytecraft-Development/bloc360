import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants/responsive.dart';
import '../association_support.dart';
import 'components/dashboard_content.dart';
import 'components/drawer_menu.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool? _hasAssociation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssociationStatus();
  }
  Future<void> _fetchAssociationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _accessToken = prefs.getString('access_token');
    String? token = _accessToken;
    const API_URL = String.fromEnvironment('API_URL');
    final String baseUrl = API_URL;
    try {
      var url = Uri.parse('$baseUrl/redirectByRole');
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        setState(() {
          _hasAssociation = response.body.contains("/dashboard");
          _isLoading = false;
        });
      } else {
        print('Error fetching association status: ${response.statusCode}');
        print('Error body: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Exception in fetching association status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: DrawerMenu()),
            Expanded(
              flex: 6,
              child: _hasAssociation ?? false ? DashboardContent() : AssociationSupport(),
            ),
          ],
        ),
      ),
    );
  }
}