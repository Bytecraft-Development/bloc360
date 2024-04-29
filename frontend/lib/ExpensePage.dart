import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DateTime _selectedDate = DateTime.now();
  List<String> expenses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showDatePicker(context);
            },
            child: Text('Select Date'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length + 1,
              itemBuilder: (context, index) {
                if (index == expenses.length) {
                  return ListTile(
                    title: Text('Add Expense'),
                    onTap: () {
                      _addExpense();
                    },
                  );
                }
                return ListTile(
                  title: Text(expenses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2023),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _addExpense() {
    setState(() {
      expenses.add('New Expense');
    });
  }
}
