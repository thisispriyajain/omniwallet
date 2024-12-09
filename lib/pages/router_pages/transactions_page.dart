import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../cubits/transaction/cubit/transaction_cubit.dart';
import '../../model/transaction.dart' as model;
import '../../widgets/category_filter_sheet.dart';
import '../../widgets/transaction_card.dart';
import 'new_transaction.dart';
import 'transaction_details.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<model.Transaction> _transactions = [];
  List<model.Transaction> _filteredTransactions = [];
  DateTime? _selectedDate;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'No authenticated user.';
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("transactions")
          .get();
      final transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return model.Transaction(
          merchant: data['merchant'] ?? '',
          date: data['date'] ?? '',
          category: data['category'] ?? '',
          amount: (data['amount'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          location: data['location'] ?? '',
        );
      }).toList();

      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load transactions: $e')),
      );
    }
  }

  void _filterTransactions(String query) {
    setState(() {
      _filteredTransactions = _transactions
          .where((transaction) =>
              transaction.merchant.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _filteredTransactions = _transactions;
      _selectedDate = null;
      _selectedCategory = null;
    });
  }

  void _filterByDate(DateTime selectedDate) {
    final dateFormat = DateFormat('MM/dd/yyyy');

    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        try {
          final transactionDate = dateFormat.parse(transaction.date);
          return transactionDate.year == selectedDate.year &&
              transactionDate.month == selectedDate.month &&
              transactionDate.day == selectedDate.day;
        } catch (e) {
          print("Error parsing date: $e");
          return false;
        }
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredTransactions = _transactions
          .where((transaction) => transaction.category == category)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OmniWallet',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Color(0xFF0093FF),
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          'Add a Transaction',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Color(0xFF0093FF)),
                        ),
                        onTap: () {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No authenticated user.')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewTransaction(
                                onAddTransaction: (newTransaction) {
                                  // setState(() {
                                  //   //_transactions.add(newTransaction);
                                  //   //_filteredTransactions.add(newTransaction);
                                  // });
                                  _fetchTransactions();
                                },
                                userID: user.uid,
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: const Color(0xFF0093FF).withOpacity(0.2),
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        leading: const Icon(Icons.qr_code_scanner,
                            color: Color(0xFF0093FF)),
                        title: Text(
                          'Scan',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Color(0xFF0093FF)),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add_circle, color: Color(0xFF0093FF)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0093FF)),
                hintText: 'Search merchants',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Color(0xFF0093FF)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF0093FF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      const BorderSide(color: Color(0xFF0093FF), width: 2.0),
                ),
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Color(0xFF0093FF)),
              onChanged: _filterTransactions,
            ),
            const SizedBox(height: 16.0),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: _clearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0093FF),
                  ),
                  child: Text(
                    'Show All',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF0093FF),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      _filterByDate(pickedDate);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0093FF),
                  ),
                  child: Text(
                    'Select Date',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Center(
                                child: Text(
                                  'Food',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Color(0xFF0093FF)),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _filterByCategory('Food');
                              },
                            ),
                            Divider(
                              color: const Color(0xFF0093FF).withOpacity(0.2),
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            ListTile(
                              title: Center(
                                child: Text(
                                  'Bill',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Color(0xFF0093FF)),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _filterByCategory('Bill');
                              },
                            ),
                            Divider(
                              color: const Color(0xFF0093FF).withOpacity(0.2),
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            ListTile(
                              title: Center(
                                child: Text(
                                  'Income',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Color(0xFF0093FF)),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _filterByCategory('Income');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0093FF),
                  ),
                  child: Text(
                    'Category',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _transactions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'There are no transcations at the moment.',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap the \'Add\' button in the top-right to create one!',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _filteredTransactions[index];
                          return TransactionCard(
                            transaction: transaction,
                            onDelete: () async {
                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  throw 'No authenticated user.';
                                }
                                final querySnapshot = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('transactions')
                                    .where('merchant',
                                        isEqualTo: transaction.merchant)
                                    .where('date', isEqualTo: transaction.date)
                                    .get()
                                    .then((querySnapshot) {
                                  for (var doc in querySnapshot.docs) {
                                    doc.reference.delete();
                                  }
                                });
                                setState(() {
                                  _transactions.remove(transaction);
                                  _filteredTransactions.remove(transaction);
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Failed to delete: $e')),
                                );
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetails(
                                      transaction: transaction),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
