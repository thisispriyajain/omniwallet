// import 'package:flutter/material.dart';
// import '../../model/transaction.dart';

// class NewTransaction extends StatefulWidget {
//   final Function(Transaction) onAddTransaction;

//   const NewTransaction({Key? key, required this.onAddTransaction})
//       : super(key: key);

//   @override
//   _NewTransactionPageState createState() => _NewTransactionPageState();
// }

// class _NewTransactionPageState extends State<NewTransaction> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _merchantController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   String? _selectedCategory;
//   DateTime? _selectedDate;

//   void _pickDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(primary: Color(0xFF0093FF)),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   void _addTransaction() {
//     if (_formKey.currentState!.validate() && _selectedDate != null) {
//       final newTransaction = Transaction(
//         merchant: _merchantController.text,
//         date:
//             '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
//         category: _selectedCategory!,
//         amount: double.parse(_amountController.text),
//         description: '', // Can add additional fields later
//       );

//       widget.onAddTransaction(newTransaction);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('New transaction is added'),
//           duration: Duration(seconds: 5),
//         ),
//       );

//       Navigator.pop(context);
//     } else if (_selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please select a date'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'New Transaction',
//           style: TextStyle(color: Color(0xFF0093FF)),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Color(0xFF0093FF)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start, // Align to the top
//               children: [
//                 // Date Picker
//                 ElevatedButton(
//                   onPressed: _pickDate,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0093FF),
//                   ),
//                   child: Text(
//                     _selectedDate == null
//                         ? 'Select Date'
//                         : '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),

//                 // Merchant Input
//                 TextFormField(
//                   controller: _merchantController,
//                   decoration: InputDecoration(
//                     hintText: 'Merchant',
//                     hintStyle: const TextStyle(color: Colors.grey), // Light gray placeholder
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xFF0093FF)),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                           color: Color(0xFF0093FF), width: 2.0),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the merchant';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),

//                 // Category Dropdown
//                 DropdownButtonFormField<String>(
//                   value: _selectedCategory,
//                   items: ['Food', 'Bill', 'Income']
//                       .map(
//                         (category) => DropdownMenuItem(
//                           value: category,
//                           child: Text(category),
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCategory = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Category',
//                     hintStyle: const TextStyle(color: Colors.grey), // Light gray placeholder
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xFF0093FF)),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                           color: Color(0xFF0093FF), width: 2.0),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select a category';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),

//                 // Amount Input
//                 TextFormField(
//                   controller: _amountController,
//                   decoration: InputDecoration(
//                     hintText: 'Amount',
//                     hintStyle: const TextStyle(color: Colors.grey), // Light gray placeholder
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xFF0093FF)),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                           color: Color(0xFF0093FF), width: 2.0),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the amount';
//                     }
//                     if (double.tryParse(value) == null) {
//                       return 'Please enter a valid number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32.0),

//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 229, 229, 229),
//                       ),
//                       child: const Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: _addTransaction,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0093FF),
//                       ),
//                       child: Text(
//                         'Add',
//                         style: TextStyle(color: Colors.white),
//                         ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../../model/transaction.dart' as model;

class NewTransaction extends StatefulWidget {
  final Function(model.Transaction) onAddTransaction;

  const NewTransaction({Key? key, required this.onAddTransaction})
      : super(key: key);

  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransaction> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0093FF)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _addTransactionToFirebase(model.Transaction transaction) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('transactions').add({
        'merchant': transaction.merchant,
        'date': transaction.date,
        'category': transaction.category,
        'amount': transaction.amount,
        'description': transaction.description,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add transaction to Firebase: $error'),
        ),
      );
    }
  }

  void _addTransaction() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newTransaction = model.Transaction(
        merchant: _merchantController.text,
        date:
            '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
        category: _selectedCategory!,
        amount: double.parse(_amountController.text),
        description: '', // Additional fields can be added here
      );

      widget.onAddTransaction(newTransaction);

      // Add to Firebase
      _addTransactionToFirebase(newTransaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New transaction added'),
          duration: Duration(seconds: 5),
        ),
      );

      Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Transaction',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0093FF)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0093FF),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Merchant Input
                TextFormField(
                  controller: _merchantController,
                  decoration: InputDecoration(
                    hintText: 'Merchant',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 189, 189, 189), // Hint text color
                      fontSize: 18, // Hint text size
                      fontWeight: FontWeight.w400, // Hint text weight
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF0093FF)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF0093FF), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the merchant';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: ['Food', 'Bill', 'Income']
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 189, 189, 189), // Hint text color
                      fontSize: 18, // Hint text size
                      fontWeight: FontWeight.w400, // Hint text weight
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF0093FF)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF0093FF), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Amount Input
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: 'Amount',
                      hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 189, 189, 189), // Hint text color
                      fontSize: 18, // Hint text size
                      fontWeight: FontWeight.w400, // Hint text weight
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF0093FF)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF0093FF), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 189, 189, 189), // Hint text color
                      fontSize: 18, // Hint text size
                      fontWeight: FontWeight.w400, // Hint text weight
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF0093FF)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF0093FF), width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length > 50) {
                      return 'No more than 50 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 229, 229, 229),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _addTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0093FF),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                        ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
