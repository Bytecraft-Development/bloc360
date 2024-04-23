import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'HelloWorld.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc360',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/helloworld': (context) => HelloWorldPage(),
      },
    );
  }
}
