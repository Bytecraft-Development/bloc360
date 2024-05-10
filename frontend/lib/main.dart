import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'LoginPageTest.dart';
import 'controller/simple_ui_controller.dart';
import 'package:frontend/pages/tos_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SimpleUIController());
    usePathUrlStrategy();
    return MaterialApp(
      initialRoute: '/login-page',
      routes: {
        '/login-page': (context) => LoginView(),
        '/tos': (context) => TermsOfService(),
      },
      title: 'Bloc360',
      home: LoginView(),
    );
  }
}