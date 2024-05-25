import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('example test', (WidgetTester tester) async {
    // Your integration test code here
    app.main();
    tester.pumpAndSettle();
    final emailFormField = find.byKey(Key('email'));
    final passwordFormField = find.byKey(Key('password'));
    final loginButton = find.byKey(Key('loginButton'));
    tester.enterText(emailFormField, "roman.alex.93@gmail.com");
    tester.enterText(passwordFormField, "QewqWJQpaFm8gfO");
    tester.pumpAndSettle();
    tester.tap(loginButton);
    tester.pumpAndSettle();

  });
}