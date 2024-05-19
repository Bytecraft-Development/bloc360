import 'package:flutter/material.dart';
import 'package:frontend/config/environment.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;



Future<void> checkRoleAndRedirect(BuildContext context) async {
  String? accessToken = html.window.localStorage['access_token'];
  const API_URL = String.fromEnvironment('API_URL');
  final String baseUrl = API_URL;

  if (accessToken == null) {
    throw Exception('No access token found, please log in.');
  }
  final response = await http.get(
    Uri.parse('$baseUrl/redirectByRole'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    final redirectUrl = response.body;
    if (redirectUrl.contains("admin/dashboard")) {
      context.go('/hello_world');
    } else {
      context.go('/cui_input');
    }
  } else {
    throw Exception('Failed to redirect based on role');
  }
}