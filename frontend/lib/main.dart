import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/pages/dashboard/dash_board_screen.dart';
import 'package:frontend/pages/hello_world.dart';
import 'package:frontend/pages/privacy_policy.dart';
import 'package:frontend/pages/tos.dart';
import 'package:frontend/controllers/simple_ui_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/controller.dart';
import 'pages/registration.dart';
import 'pages/login.dart';
import 'pages/expenses.dart';
import 'pages/redirect.dart';
import 'pages/create_association.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/login-page',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => Controller(),
          child: DashBoardScreen(),
        ),
      ),
      GoRoute(
        path: '/login-page',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/hello',
        builder: (context, state) => HelloWorldPage(),
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
      GoRoute(
        path: '/redirect',
        builder: (context, state) => RedirectView (),
      ),
      GoRoute(
        path: '/createAssociation',
        builder: (context, state) => CreateAssociationPage (),
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
