// import 'package:flutter/material.dart';

// import '../../model/transaction.dart';
// import '../../widgets/transaction_card.dart';
// import 'new_transaction.dart';
// import 'transaction_details.dart';



// class TransactionsPage extends StatefulWidget {
//   const TransactionsPage({super.key});

//   @override
//   _TransactionsPageState createState() => _TransactionsPageState();
// }

// class _TransactionsPageState extends State<TransactionsPage> {
//   final List<Transaction> _transactions = [
//     Transaction(
//       merchant: 'Starbucks',
//       date: '11/24/2024',
//       category: 'Food & Drinks',
//       amount: -15.75,
//       description: 'Coffee and snacks',
//     ),
//     Transaction(
//       merchant: 'Salary',
//       date: '11/15/2024',
//       category: 'Income',
//       amount: 2000.0,
//       description: 'Monthly paycheck',
//     ),
//     // Add more sample transactions here...
//   ];

//   String _searchQuery = '';
//   DateTime? _selectedDate;

//   List<Transaction> get _filteredTransactions {
//     final query = _searchQuery.toLowerCase();
//     return _transactions.where((transaction) {
//       final matchesMerchant =
//           transaction.merchant.toLowerCase().contains(query);
//       final matchesDate = _selectedDate == null ||
//           transaction.date == _formatDate(_selectedDate!);
//       return matchesMerchant && matchesDate;
//     }).toList();
//   }

//   String _formatDate(DateTime date) {
//     return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
//   }

//   void _pickDate(BuildContext context) async {
//     final selected = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );

//     if (selected != null) {
//       setState(() {
//         _selectedDate = selected;
//       });
//     }
//   }

//   void _deleteTransaction(Transaction transaction) {
//     setState(() {
//       _transactions.remove(transaction);
//     });
//   }

//   void _viewTransactionDetails(Transaction transaction) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TransactionDetailPage(transaction: transaction),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final transactions = _filteredTransactions;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'OmniWallet',
//           style: TextStyle(
//             color: Color(0xFF0093FF),
//             fontSize: 45,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Search Field
//             TextField(
//               onChanged: (value) => setState(() {
//                 _searchQuery = value;
//               }),
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.search, color: Color(0xFF0093FF)),
//                 hintText: 'Search merchants',
//                 hintStyle: const TextStyle(color: Color(0xFF0093FF)),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: const BorderSide(color: Color(0xFF0093FF)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide:
//                       const BorderSide(color: Color(0xFF0093FF), width: 2.0),
//                 ),
//               ),
//               style: const TextStyle(color: Color(0xFF0093FF)),
//             ),
//             const SizedBox(height: 16.0),

//             // Date Picker
//             ElevatedButton.icon(
//               onPressed: () => _pickDate(context),
//               icon: const Icon(Icons.calendar_today),
//               label: Text(
//                 _selectedDate == null
//                     ? 'Select Date'
//                     : _formatDate(_selectedDate!),
//               ),
//             ),
//             const SizedBox(height: 16.0),

//             // Transaction List
//             Expanded(
//               child: transactions.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: transactions.length,
//                       itemBuilder: (context, index) {
//                         final transaction = transactions[index];
//                         return TransactionCard(
//                           transaction: transaction,
//                           onDelete: () => _deleteTransaction(transaction),
//                           onTap: () => _viewTransactionDetails(transaction),
//                         );
//                       },
//                     )
//                   : const Center(
//                       child: Text(
//                         '0 result',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../cubits/transaction/cubit/transaction_cubit.dart';
// import '../../model/transaction.dart';
// import '../../widgets/category_filter_sheet.dart';
// import '../../widgets/transaction_card.dart';

// class TransactionsPage extends StatelessWidget {
//   final List<Transaction> transactions;

//   const TransactionsPage({Key? key, required this.transactions})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TransactionsCubit(transactions), // Provide your Bloc here
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'OmniWallet',
//             style: TextStyle(
//               color: Color(0xFF0093FF),
//               fontSize: 45,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//                   ),
//                   builder: (context) {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ListTile(
//                           title: Text(
//                             'Add a Transaction',
//                             style: TextStyle(color: Color(0xFF0093FF)),
//                           ),
//                           onTap: () {
//                             // Navigate using GoRouter pushNamed
//                             Navigator.pop(context);
//                             context.pushNamed('newTransaction');
//                           },
//                         ),
//                         Divider(
//                           color: Color(0xFF0093FF).withOpacity(0.2),
//                           thickness: 1,
//                           indent: 20,
//                           endIndent: 20,
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.qr_code_scanner, color: Color(0xFF0093FF)),
//                           title: Text(
//                             'Scan',
//                             style: TextStyle(color: Color(0xFF0093FF)),
//                           ),
//                           onTap: () {
//                             Navigator.pop(context);
//                             // Handle Scan
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(Icons.add_circle, color: Color(0xFF0093FF)),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Search Field
//               TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.search, color: Color(0xFF0093FF)),
//                   hintText: 'Search merchants',
//                   hintStyle: const TextStyle(color: Color(0xFF0093FF)),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: const BorderSide(color: Color(0xFF0093FF)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2.0),
//                   ),
//                 ),
//                 style: const TextStyle(color: Color(0xFF0093FF)),
//                 onChanged: (query) {
//                   // Filter transactions based on the search query
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               // Date Picker and Filters
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle clear filters
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0093FF),
//                     ),
//                     child: const Text(
//                       'Show All',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 4.0),
//                   ElevatedButton(
//                     onPressed: () async {
//                       DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                         builder: (context, child) {
//                           return Theme(
//                             data: ThemeData.light().copyWith(
//                               colorScheme: const ColorScheme.light(
//                                 primary: Color(0xFF0093FF),
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       if (pickedDate != null) {
//                         // Filter transactions by date
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0093FF),
//                     ),
//                     child: const Text(
//                       'Select Date',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   const SizedBox(width: 4.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Show category filter modal
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF0093FF),
//                     ),
//                     child: const Text(
//                       'Category',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               // Transactions List
//               Expanded(
//                 child: BlocBuilder<TransactionsCubit, TransactionState>(
//                   builder: (context, state) {
//                     if (state is TransactionLoaded) {
//                       final transactions = state.transactions;
//                       return transactions.isEmpty
//                           ? const Center(child: Text('No transactions found'))
//                           : ListView.builder(
//                               itemCount: transactions.length,
//                               itemBuilder: (context, index) {
//                                 final transaction = transactions[index];
//                                 return Dismissible(
//                                   key: ValueKey(transaction),
//                                   direction: DismissDirection.endToStart,
//                                   background: Container(
//                                     alignment: Alignment.centerRight,
//                                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                     color: Colors.red,
//                                     child: const Icon(Icons.delete, color: Colors.white),
//                                   ),
//                                   onDismissed: (_) {
//                                     context.read<TransactionsCubit>().removeTransaction(transaction);
//                                   },
//                                   child: TransactionCard(
//                                   transaction: transaction,
//                                     onDelete: () {
//                                       context.read<TransactionsCubit>().removeTransaction(transaction);
//                                       },
//                                     onTap: () {
//                                       context.pushNamed('transactionDetails', extra: transaction);
//                                     },
//                                   ),
//                                 );
//                               },
//                             );
//                     } else {
//                       return const Center(child: Text('Failed to load transactions'));
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../cubits/transaction/cubit/transaction_cubit.dart';
// import '../../model/transaction.dart';
// import '../../widgets/category_filter_sheet.dart';
// import '../../widgets/transaction_card.dart';
// import 'new_transaction.dart';
// import 'transaction_details.dart';


// class TransactionsPage extends StatefulWidget {
//   const TransactionsPage({Key? key}) : super(key: key);

//   @override
//   _TransactionsPageState createState() => _TransactionsPageState();
// }

// class _TransactionsPageState extends State<TransactionsPage> {
//   List<Transaction> _transactions = Transaction.mockTransactions();
//   List<Transaction> _filteredTransactions = [];
//   DateTime? _selectedDate;
//   String? _selectedCategory;

//   @override
//   void initState() {
//     super.initState();
//     _filteredTransactions = _transactions;
//   }

//   void _filterTransactions(String query) {
//     setState(() {
//       _filteredTransactions = _transactions
//           .where((transaction) => transaction.merchant
//               .toLowerCase()
//               .contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _clearFilters() {
//     setState(() {
//       _filteredTransactions = _transactions;
//       _selectedDate = null;
//       _selectedCategory = null;
//     });
//   }

//   void _filterByDate(DateTime selectedDate) {
//     setState(() {
//       _filteredTransactions = _transactions.where((transaction) {
//         // Convert the date string to DateTime, assuming `transaction.date` is a string
//         final transactionDate = DateTime.parse(transaction.date);
//         return  transactionDate.month == selectedDate.month &&
//             transactionDate.day == selectedDate.day &&
//             transactionDate.year == selectedDate.year;
//       }).toList();
//     });
//   }

//   void _filterByCategory(String category) {
//     setState(() {
//       _selectedCategory = category;
//       _filteredTransactions = _transactions
//           .where((transaction) => transaction.category == category)
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'OmniWallet',
//           style: TextStyle(
//             color: Color(0xFF0093FF),
//             fontSize: 45,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               showModalBottomSheet(
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//                 ),
//                 builder: (context) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ListTile(
//                         title: Text(
//                           'Add a Transaction',
//                           style: TextStyle(color: Color(0xFF0093FF)),
//                         ),
//                         // onTap: () {
//                         //   Navigator.pop(context);
//                         //   // Navigate to New Transaction Page
//                         // },
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => NewTransaction(
//                                 onAddTransaction: (newTransaction) {
//                                   setState(() {
//                                     _transactions.add(newTransaction);
//                                   });
//                                 },
//                               ),
//                             ),
//                           );
//                         },

//                       ),
//                       Divider(
//                         color: Color(0xFF0093FF).withOpacity(0.2),
//                         thickness: 1,
//                         indent: 20,
//                         endIndent: 20,
//                       ),
//                       ListTile(
//                         leading: const Icon(Icons.qr_code_scanner, color: Color(0xFF0093FF)),
//                         title: Text(
//                           'Scan',
//                           style: TextStyle(color: Color(0xFF0093FF)),
//                         ),
//                         onTap: () {
//                           Navigator.pop(context);
//                           // Handle Scan
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.add_circle, color: Color(0xFF0093FF)),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Search Field
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.search, color: Color(0xFF0093FF)),
//                 hintText: 'Search merchants',
//                 hintStyle: const TextStyle(color: Color(0xFF0093FF)),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: const BorderSide(color: Color(0xFF0093FF)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2.0),
//                 ),
//               ),
//               style: const TextStyle(color: Color(0xFF0093FF)),
//               onChanged: _filterTransactions,
//             ),
//             const SizedBox(height: 16.0),
//             // Date Picker and Filters
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: _clearFilters,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0093FF),
//                   ),
//                   child: const Text(
//                     'Show All',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 4.0),
//                 ElevatedButton(
//                   onPressed: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                       builder: (context, child) {
//                         return Theme(
//                           data: ThemeData.light().copyWith(
//                             colorScheme: const ColorScheme.light(
//                               primary: Color(0xFF0093FF),
//                             ),
//                           ),
//                           child: child!,
//                         );
//                       },
//                     );
//                     if (pickedDate != null) {
//                       _filterByDate(pickedDate);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0093FF),
//                   ),
//                   child: const Text(
//                     'Select Date',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 4.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     showModalBottomSheet(
//                       context: context,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//                       ),
//                       builder: (context) {
//                         return Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             ListTile(
//                               title: Center(
//                                 child: Text(
//                                   'Food',
//                                   style: TextStyle(color: Color(0xFF0093FF)),
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 _filterByCategory('Food');
//                               },
//                             ),
//                             Divider(
//                               color: Color(0xFF0093FF).withOpacity(0.2),
//                               thickness: 1,
//                               indent: 20,
//                               endIndent: 20,
//                             ),
//                             ListTile(
//                               title: Center(
//                                 child: Text(
//                                   'Bill',
//                                   style: TextStyle(color: Color(0xFF0093FF)),
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 _filterByCategory('Bill');
//                               },
//                             ),
//                             Divider(
//                               color: Color(0xFF0093FF).withOpacity(0.2),
//                               thickness: 1,
//                               indent: 20,
//                               endIndent: 20,
//                             ),
//                             ListTile(
//                               title: Center(
//                                 child: const Text(
//                                   'Income',
//                                   style: TextStyle(color: Color(0xFF0093FF)),
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 _filterByCategory('Income');
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0093FF),
//                   ),
//                   child: const Text(
//                     'Category',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             // Transactions List
//             Expanded(
//               child: _filteredTransactions.isEmpty
//                   ? const Center(child: Text('Not found'))
//                   : ListView.builder(
//                       itemCount: _filteredTransactions.length,
//                       itemBuilder: (context, index) {
//                         final transaction = _filteredTransactions[index];
//                         return Dismissible(
//                           key: ValueKey(transaction),
//                           direction: DismissDirection.endToStart,
//                           background: Container(
//                             alignment: Alignment.centerRight,
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                             color: Colors.red,
//                             child: const Icon(Icons.delete, color: Colors.white),
//                           ),
//                           onDismissed: (_) {
//                             setState(() {
//                               _transactions.remove(transaction);
//                             });
//                           },
//                           child: TransactionCard(
//                             transaction: transaction,
//                             onDelete: () {
//                               setState(() {
//                                 _transactions.remove(transaction);
//                               });
//                             },
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       TransactionDetails(transaction: transaction),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../cubits/transaction/cubit/transaction_cubit.dart';
import '../../model/transaction.dart' as model;
import '../../widgets/category_filter_sheet.dart';
import '../../widgets/transaction_card.dart';
import 'new_transaction.dart';
import 'transaction_details.dart';


class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

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
    _fetchTransactions(); // Fetch transactions from Firestore
  }
  Future<void> _fetchTransactions() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('transactions').get();
      final transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return model.Transaction(
          merchant: data['merchant'] ?? '',
          date: data['date'] ?? '',
          category: data['category'] ?? '',
          amount: (data['amount'] ?? 0).toDouble(),
          description: data['description'] ?? '',
        );
      }).toList();

      setState(() {
        _transactions = transactions;
        _filteredTransactions = transactions; // Show all transactions initially
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
          .where((transaction) => transaction.merchant
              .toLowerCase()
              .contains(query.toLowerCase()))
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
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        // Convert the date string to DateTime, assuming `transaction.date` is a string
        final transactionDate = DateTime.parse(transaction.date);
        return  transactionDate.month == selectedDate.month &&
            transactionDate.day == selectedDate.day &&
            transactionDate.year == selectedDate.year;
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
        title: const Text(
          'OmniWallet',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 45,
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          'Add a Transaction',
                          style: TextStyle(color: Color(0xFF0093FF)),
                        ),
                        // onTap: () {
                        //   Navigator.pop(context);
                        //   // Navigate to New Transaction Page
                        // },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewTransaction(
                                onAddTransaction: (newTransaction) {
                                  setState(() {
                                    _transactions.add(newTransaction);
                                  });
                                },
                              ),
                            ),
                          );
                        },

                      ),
                      Divider(
                        color: Color(0xFF0093FF).withOpacity(0.2),
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        leading: const Icon(Icons.qr_code_scanner, color: Color(0xFF0093FF)),
                        title: Text(
                          'Scan',
                          style: TextStyle(color: Color(0xFF0093FF)),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // Handle Scan
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
            // Search Field
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0093FF)),
                hintText: 'Search merchants',
                hintStyle: const TextStyle(color: Color(0xFF0093FF)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF0093FF)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Color(0xFF0093FF), width: 2.0),
                ),
              ),
              style: const TextStyle(color: Color(0xFF0093FF)),
              onChanged: _filterTransactions,
            ),
            const SizedBox(height: 16.0),
            // Date Picker and Filters
            Row(
              children: [
                ElevatedButton(
                  onPressed: _clearFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0093FF),
                  ),
                  child: const Text(
                    'Show All',
                    style: TextStyle(color: Colors.white),
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
                          data: ThemeData.light().copyWith(
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
                  child: const Text(
                    'Select Date',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
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
                                  style: TextStyle(color: Color(0xFF0093FF)),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _filterByCategory('Food');
                              },
                            ),
                            Divider(
                              color: Color(0xFF0093FF).withOpacity(0.2),
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            ListTile(
                              title: Center(
                                child: Text(
                                  'Bill',
                                  style: TextStyle(color: Color(0xFF0093FF)),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _filterByCategory('Bill');
                              },
                            ),
                            Divider(
                              color: Color(0xFF0093FF).withOpacity(0.2),
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            ListTile(
                              title: Center(
                                child: const Text(
                                  'Income',
                                  style: TextStyle(color: Color(0xFF0093FF)),
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
                  child: const Text(
                    'Category',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Transactions List
            Expanded(
              child: _transactions.isEmpty
              ? const Center(
                  child: Text(
                    'No Transactions Found',
                    style: TextStyle(fontSize: 16),
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
                            // Delete transaction from Firestore
                            await FirebaseFirestore.instance
                                .collection('transactions')
                                .where('merchant', isEqualTo: transaction.merchant)
                                .where('date', isEqualTo: transaction.date)
                                .get()
                                .then((querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                doc.reference.delete();
                              }
                            });

                            // Update local state
                            setState(() {
                              _transactions.remove(transaction);
                              _filteredTransactions.remove(transaction);
                            });
                          } catch (e) {
                            // Handle delete error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete: $e')),
                            );
                          }
                        },
                        onTap: () {
                          // Navigate to transaction details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TransactionDetails(transaction: transaction),
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

