import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/pages/dashboard/components/custom_appbar.dart';

import 'add_block.dart';
import 'add_house.dart';

class AddBlocksAndHousesPage extends StatefulWidget {
  final int associationId;

  AddBlocksAndHousesPage({required this.associationId});

  @override
  _AddBlocksAndHousesPageState createState() => _AddBlocksAndHousesPageState();
}

class _AddBlocksAndHousesPageState extends State<AddBlocksAndHousesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blocks and Houses')),
      body: Column(
        children: [
          Expanded(
            child: AddBlockPage(associationId: widget.associationId),
          ),
          Divider(), // Separă cele două formulare
          Expanded(
            child: AddHousePage(associationId: widget.associationId),
          ),
        ],
      ),
    );
  }
}


