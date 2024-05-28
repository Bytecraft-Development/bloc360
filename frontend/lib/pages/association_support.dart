import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssociationSupport extends StatefulWidget {
  @override
  _AssociationSupportState createState() => _AssociationSupportState();
}

class _AssociationSupportState extends State<AssociationSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Association Support'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You don\'t have any association created. Do you want to create one?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/create_association'),
              child: Text('Create Association'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/contact_support'),
              child: Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }
}

