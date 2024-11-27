import 'package:flutter/material.dart';
import '../../model/transaction.dart';

class NewTransactionPage extends StatefulWidget {
  final Function(Transaction) onAddTransaction;

  const NewTransactionPage({Key? key, required this.onAddTransaction}) : super(key: key);

  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedCategory != null) {
      final newTransaction = Transaction(
        merchant: _merchantController.text,
        date: "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
        category: _selectedCategory!,
        amount: double.parse(_amountController.text),
        description: '',
      );

      widget.onAddTransaction(newTransaction);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("New transaction is added"),
          duration: const Duration(seconds: 5),
        ),
      );

      Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date")),
      );
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Transaction',
          style: TextStyle(color: Color(0xFF0093FF)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0093FF)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Merchant Input
              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  labelText: "Merchant",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a merchant name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Date Picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF0093FF), width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? "Select Date"
                        : "${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Food", child: Text("Food")),
                  DropdownMenuItem(value: "Bill", child: Text("Bill")),
                  DropdownMenuItem(value: "Income", child: Text("Income")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a category";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Amount Input
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an amount";
                  }
                  final double? parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0093FF),
                    ),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
