import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants/responsive.dart';
import '../../models/big_decimal.dart';
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
  BigDecimal? _totalPaymentAmount;
  int? _numberOfHouseholds;

  @override
  void initState() {
    super.initState();
    _fetchAssociationStatus();
    _fetchDashboardData();
  }

  Future<void> _fetchAssociationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _accessToken = prefs.getString('access_token');
    const API_URL = String.fromEnvironment('API_URL');
    final String baseUrl = API_URL;
    try {
      var url = Uri.parse('$baseUrl/redirectByRole');
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $_accessToken',
      });
      if (response.statusCode == 200) {
        setState(() {
          _hasAssociation = response.body.contains("/dashboard");
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<BigDecimal?> fetchTotalPaymentAmount(String token) async {
    const API_URL = String.fromEnvironment('API_URL');
    final String baseUrl = API_URL;
    var url = Uri.parse('$baseUrl/total-payment');

    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is int || jsonResponse is double) {
          return BigDecimal(jsonResponse.toString());
        } else {
          return null;
        }
      } else {
        print('Failed to load total payment amount');
        return null;
      }
    } catch (e) {
      print('Exception in fetchTotalPaymentAmount: $e');
      return null;
    }
  }

  Future<int?> fetchNumberOfHouseholds(String token) async {
    const API_URL = String.fromEnvironment('API_URL');
    final String baseUrl = API_URL;
    var url = Uri.parse('$baseUrl/number-of-households');

    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Parsed JSON: $jsonResponse');
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('numberOfHouseholds')) {
          return jsonResponse['numberOfHouseholds'];
        } else if (jsonResponse is int) {
          return jsonResponse;
        } else {
          print('Unexpected JSON format');
          return null;
        }
      } else {
        print('Failed to load number of households');
        return null;
      }
    } catch (e) {
      print('Exception in fetchNumberOfHouseholds: $e');
      return null;
    }
  }

  Future<void> _fetchDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _accessToken = prefs.getString('access_token');
    try {
      final totalPaymentAmount = await fetchTotalPaymentAmount(_accessToken!);
      final numberOfHouseholds = await fetchNumberOfHouseholds(_accessToken!);

      setState(() {
        _totalPaymentAmount = totalPaymentAmount;
        _numberOfHouseholds = numberOfHouseholds;
      });
    } catch (e) {
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
              child: _hasAssociation ?? false
                  ? DashboardContent(
                totalPaymentAmount: _totalPaymentAmount,
                numberOfHouseholds: _numberOfHouseholds,
              )
                  : AssociationSupport(),
            ),
          ],
        ),
      ),
    );
  }
}