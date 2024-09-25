import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/pages/add_block.dart';
import 'package:frontend/pages/add_stairs.dart';
import 'package:frontend/pages/dashboard/dash_board_screen.dart';
import 'package:frontend/pages/hello_world.dart';
import 'package:frontend/pages/privacy_policy.dart';
import 'package:frontend/pages/select_block.dart';
import 'package:frontend/pages/tos.dart';
import 'package:frontend/controllers/simple_ui_controller.dart';
import 'package:frontend/util/token_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/controller.dart';
import 'pages/registration.dart';
import 'pages/login.dart';
import 'pages/expenses.dart';
import 'pages/association_support.dart';
import 'pages/create_association.dart';
import 'pages/add_block.dart';
// just for update

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const publicPaths = ['/login', '/register', '/reset-password', '/tos', '/privacy'];

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => _buildRouteWithTokenValidation(
          context,
          state,
          ChangeNotifierProvider(
            create: (context) => Controller(),
            child: const DashBoardScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/hello',
        builder: (context, state) =>
            _buildRouteWithTokenValidation(context, state, const HelloWorldPage()),
      ),
      GoRoute(
        path: '/tos',
        builder: (context, state) => TermsOfService(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicy(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) =>
            _buildRouteWithTokenValidation(context, state, ExpensePage()),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => SignUpView(),
      ),
      /*GoRoute(
        path: '/add_block',
        builder: (context, state) {
          final associationId = state.extra as int;
          return AddBlockPage(associationId: associationId);
        },
      ),*/
      GoRoute(
        path: '/add_stairs',
        builder: (context, state) {
          final blockId = state.extra as int;
          return AddStairsPage(blockId: blockId);
        },
      ),
      GoRoute(
        path: '/createAssociation',
        builder: (context, state) =>
            _buildRouteWithTokenValidation(context, state, CreateAssociationPage()),
      ),
      GoRoute(
        path: '/select_block',
        builder: (context, state) => BlockListPage(),
      ),
      GoRoute(
        path:'/association_support',
        builder: (context, state) => _buildRouteWithTokenValidation(
            context, state, AssociationSupport()),
      )
    ],
    redirect: (context, state) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      final isTokenValid = await TokenUtils().isTokenValid(accessToken ?? '');
      if (isTokenValid == false && !publicPaths.contains(state.fullPath))  {
        return '/login';
      }
      return null;
    },
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

  static Widget _buildRouteWithTokenValidation(
      BuildContext context, GoRouterState state, Widget page) {
    return FutureBuilder<String?>(
      future: _validateAndRefreshToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return page;
        } else {
          return const LoginView();
        }
      },
    );
  }

  static Future<String?> _validateAndRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final isTokenValid = await TokenUtils().isTokenValid(accessToken ?? '');

    if (isTokenValid) {
      return accessToken;
    } else {
      final refreshToken = prefs.getString('refresh_token');
      if (refreshToken != null) {
        final newAccessToken =
        await TokenUtils().refreshToken(refreshToken);
        return newAccessToken;
      }
    }
    return null;
  }
  Future<int?> getAssociationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('association_id');
  }
}