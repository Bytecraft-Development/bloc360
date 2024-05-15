import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/pages/privacy_policy.dart';
import 'package:frontend/pages/tos_page.dart';
import 'package:frontend/views/main/main_view.dart';
import 'package:get/get.dart';

import 'LoginPageTest.dart';
import 'controller/simple_ui_controller.dart';

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
        '/privacy': (context) => const PrivacyPolicy(),
      },
      title: 'Bloc360',
      home: MainView(),
    );
  }
}
