import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/pages/privacy_policy.dart';
import 'package:frontend/pages/tos_page.dart';
import 'package:frontend/views/main/main_view.dart';
import 'package:frontend/controller/simple_ui_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'RegistrationPageTest.dart';
import 'LoginPageTest.dart';
import 'ExpensePage.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MainView(),
      ),
      GoRoute(
        path: '/login-page',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/tos',
        builder: (context, state) => TermsOfService(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => PrivacyPolicy(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => ExpensePage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => SignUpView(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    Get.put(SimpleUIController());
    return MaterialApp.router(
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      title: 'Bloc360',
    );
  }
}