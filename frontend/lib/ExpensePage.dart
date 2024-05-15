import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Expense {
  final int id;
  final String type;
  final bool consumable;
  final bool repeatable;
  final bool distribute;
  final String serialNumber;
  final DateTime documentDate;
  final DateTime dueDate;
  final double amount;
  final String description;
  final String reference;

  Expense({
    required this.id,
    required this.type,
    required this.consumable,
    required this.repeatable,
    required this.distribute,
    required this.serialNumber,
    required this.documentDate,
    required this.dueDate,
    required this.amount,
    required this.description,
    required this.reference,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      type: json['type'],
      consumable: json['consumable'],
      repeatable: json['repeatable'],
      distribute: json['distribute'],
      serialNumber: json['serialNumber'],
      documentDate: DateTime.now(),
      dueDate: DateTime.now(),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'consumable': consumable,
      'repeatable': repeatable,
      'distribute': distribute,
      'serialNumber': serialNumber,
      'documentDate': documentDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'description': description,
      'reference': reference,
    };
  }
}

class ExpenseService {
  static const API_URL = String.fromEnvironment('API_URL');
  final String baseUrl = API_URL;

  Future<List<Expense>> getAllExpenses() async {
    final response = await http.get(Uri.parse('$baseUrl/expenses'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map<Expense>((expense) => Expense.fromJson(expense)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<Expense> createExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$baseUrl/createExpense'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 200) {
      return Expense.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create expense');
    }
  }

  Future<Expense> updateExpense(int id, Expense expense) async {
    final response = await http.put(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 200) {
      return Expense.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update expense');
    }
  }

  Future<void> deleteExpense(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/expenses/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete expense');
    }
  }
}

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final ExpenseService expenseService = ExpenseService();
  late Future<List<Expense>> futureExpenses;
  final TextEditingController typeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDocumentDate;
  DateTime? selectedDueDate;

  @override
  void initState() {
    super.initState();
    futureExpenses = expenseService.getAllExpenses();
  }

  void _createExpense() {
    if (selectedDocumentDate == null || selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select dates')),
      );
      return;
    }

    Expense newExpense = Expense(
      id: 0,
      type: typeController.text,
      consumable: false,
      repeatable: false,
      distribute: false,
      serialNumber: '',
      documentDate: selectedDocumentDate!,
      dueDate: selectedDueDate!,
      amount: double.parse(amountController.text),
      description: descriptionController.text,
      reference: '',
    );

    expenseService.createExpense(newExpense).then((expense) {
      setState(() {
        futureExpenses = expenseService.getAllExpenses();
      });
    });
  }

  void _deleteExpense(int id) {
    expenseService.deleteExpense(id).then((_) {
      setState(() {
        futureExpenses = expenseService.getAllExpenses();
      });
    });
  }

  Future<void> _selectDate(BuildContext context, {required bool isDocumentDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isDocumentDate) {
          selectedDocumentDate = picked;
        } else {
          selectedDueDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: Center(
        child: Column(
          children: [
            // Antetul tabelului
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Document Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Divider(thickness: 2),
            // Lista de cheltuieli
            Expanded(
              child: FutureBuilder<List<Expense>>(
                future: futureExpenses,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final expense = snapshot.data![index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(expense.type),
                              Text(expense.amount.toString()),
                              Text(expense.description),
                              Text(expense.documentDate.toLocal().toString().split(' ')[0]),
                              Text(expense.dueDate.toLocal().toString().split(' ')[0]),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteExpense(expense.id),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Expense"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: typeController,
                        decoration: InputDecoration(labelText: "Type"),
                      ),
                      TextField(
                        controller: amountController,
                        decoration: InputDecoration(labelText: "Amount"),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: "Description"),
                      ),
                      ListTile(
                        title: Text(
                          selectedDocumentDate == null
                              ? 'Select Document Date'
                              : selectedDocumentDate!.toLocal().toString().split(' ')[0],
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context, isDocumentDate: true),
                      ),
                      ListTile(
                        title: Text(
                          selectedDueDate == null
                              ? 'Select Due Date'
                              : selectedDueDate!.toLocal().toString().split(' ')[0],
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context, isDocumentDate: false),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Add"),
                    onPressed: () {
                      _createExpense();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}