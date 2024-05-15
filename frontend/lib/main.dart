import 'package:flutter/material.dart';
import 'package:frontend/views/dashboard/dashboard_view.dart';
import 'package:frontend/views/main/main_view.dart';
import 'package:frontend/views/main/main_viewmodel.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'LoginPageTest.dart';
import 'ExpensePage.dart';
import 'controller/simple_ui_controller.dart';
import 'package:frontend/pages/tos_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SimpleUIController());
    return MaterialApp(
      initialRoute: '/login-page',
      routes: {
        '/login-page': (context) => LoginView(),
        '/tos': (context) => TermsOfService(),
        '/expense': (context) => ExpensePage(),
      },
      title: 'Bloc360',
      home: MainView(),
    );
  }
}
