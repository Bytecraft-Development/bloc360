import 'package:flutter/material.dart';
import 'package:frontend/LoginPage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'LoginPageTest.dart';
import 'controller/simple_ui_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SimpleUIController());
    return MaterialApp(
      title: 'My App',
      home: LoginView(),
    );
  }
}
