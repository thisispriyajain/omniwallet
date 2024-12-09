import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../model/transaction.dart' as model;
import '../../services/location_service.dart';

class NewTransaction extends StatefulWidget {
  final Function(model.Transaction) onAddTransaction;
  final String userID;

  const NewTransaction(
    {Key? key, required this.onAddTransaction, required this.userID})
      : super(key: key);

  @override
  _NewTransactionPageState createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransaction> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final LocationService _locationService = LocationService();
  List<String> _recommendedLocations = [];
  String? _selectedLocation;
  String? _selectedCategory;
  DateTime? _selectedDate;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommendedLocations();
  }

  Future<void> _fetchRecommendedLocations() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      final locations = await _locationService.fetchRecommendedLocations(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _recommendedLocations = ["Current Location", ...locations];
      });
    } catch (error) {
      print("Error fetching locations: $error");
      setState(() {
        _recommendedLocations = ["Current Location", "Error fetching locations"];
      });
    }
  }

  /// Get the current location and update the selected location.
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Location services are disabled. Please enable them.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        _showSnackBar(
            'Location permissions are permanently denied. Enable them in settings.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLocation =
            'Lat: ${position.latitude}, Long: ${position.longitude}';
        print(_selectedLocation);
      });
    } catch (error) {
      _showSnackBar('Failed to fetch current location: $error');
    }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


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

  /// Add a new transaction to Firebase and call the parent callback.
  Future<void> _addTransactionToFirebase(model.Transaction transaction) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not exist')),
        );
        return;
      }      
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add({
        'merchant': transaction.merchant,
        'date': transaction.date,
        'category': transaction.category,
        'amount': transaction.amount,
        'description': transaction.description,
        'location': transaction.location,
      });
    } catch (error) {
      _showSnackBar('Failed to add transaction to Firebase: $error');
    }
  }

  /// Validate and add a new transaction.
  void _addTransaction() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedLocation != null) {
      final newTransaction = model.Transaction(
        merchant: _merchantController.text,
        date:
            '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
        category: _selectedCategory!,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text,
        location: _selectedLocation!,
      );

      widget.onAddTransaction(newTransaction);
      _addTransactionToFirebase(newTransaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New transaction added')),
      );

      Navigator.pop(context);
    } else {
      if (_selectedDate == null) {
        _showSnackBar('Please select a date');
      } else if (_selectedLocation == null) {
        _showSnackBar('Please select a location');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Transaction',
          style: TextStyle(
            color: Color(0xFF0093FF),fontSize: 24,
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
              children: [
                _buildCalendarButton(),
                const SizedBox(height: 16.0),
                _buildLocationDropdown(),
                const SizedBox(height: 16.0),
                _buildFormFields(),
                const SizedBox(height: 16.0),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the calendar button for date selection.
  Widget _buildCalendarButton() {
    return GestureDetector(
      onTap: _pickDate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Color(0xFF0093FF),
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            _selectedDate == null
                ? 'Select Date'
                : '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
            style: const TextStyle(color: Color(0xFF0093FF)),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center, // Center the icon horizontally
    children: [
      IconButton(
        icon: const Icon(Icons.location_on, color: Color(0xFF0093FF)),
        onPressed: () {
          setState(() {
            _showDropdown = !_showDropdown;
          });
        },
      ),
      if (_showDropdown)
  DropdownButtonFormField<String>(
    isExpanded: true, // Ensures dropdown does not overflow
    items: _recommendedLocations
        .map((location) => DropdownMenuItem(
              value: location,
              child: Text(location),
            ))
        .toList(),
    onChanged: (value) async {
      if (value == "Current Location") {
        await _getCurrentLocation();
      } else {
        setState(() {
          _selectedLocation = value;
        });
      }
    },
    hint: const Text(
      'Select a location',
      style: TextStyle(
        color: Color.fromARGB(255, 189, 189, 189),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
    ],
  );
}

  /// Builds the transaction form fields.
  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _merchantController,
          decoration: const InputDecoration(
            hintText: 'Merchant',
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 189, 189, 189),
              fontSize: 18,
              fontWeight: FontWeight.w400,
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
          decoration: const InputDecoration(
            hintText: 'Category',
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 189, 189, 189),
              fontSize: 18,
              fontWeight: FontWeight.w400,
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

        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Amount',
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 189, 189, 189),
              fontSize: 18,
              fontWeight: FontWeight.w400,
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
          decoration: const InputDecoration(
            hintText: 'Description',
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 189, 189, 189),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),            
          ),
          validator: (value) {
            if (value!.length > 50) {
              return 'No more than 50 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds action buttons for form submission or cancellation.
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF0093FF)),
          ),
        ),
        ElevatedButton(
          onPressed: _addTransaction,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0093FF),
          ),
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../model/transaction.dart' as model;
// import '../../services/location_service.dart';

// class NewTransaction extends StatefulWidget {
//   final Function(model.Transaction) onAddTransaction;
//   final String userID;

//   const NewTransaction({Key? key, required this.onAddTransaction, required this.userID})
//       : super(key: key);

//   @override
//   _NewTransactionPageState createState() => _NewTransactionPageState();
// }

// class _NewTransactionPageState extends State<NewTransaction> {
//   // Controllers
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _merchantController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final LocationService _locationService = LocationService();
//   List<String> _recommendedLocations = [];
//   String? _selectedLocation;
//   String? _selectedCategory;
//   DateTime? _selectedDate;
//   bool _showDropdown = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRecommendedLocations();
//   }

//   /// Fetch recommended locations using the location service.
//   Future<void> _fetchRecommendedLocations() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition();
//       final locations = await _locationService.fetchRecommendedLocations(
//         position.latitude,
//         position.longitude,
//       );
//       setState(() {
//         _recommendedLocations = ["Current Location", ...locations];
//       });
//     } catch (error) {
//       print("Error fetching locations: $error");
//       setState(() {
//         _recommendedLocations = ["Current Location", "Error fetching locations"];
//       });
//     }
//   }

//   /// Get the current location and update the selected location.
//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         _showSnackBar('Location services are disabled. Please enable them.');
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever) {
//         _showSnackBar(
//             'Location permissions are permanently denied. Enable them in settings.');
//         return;
//       }

//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _selectedLocation =
//             'Lat: ${position.latitude}, Long: ${position.longitude}';
//         print(_selectedLocation);
//       });
//     } catch (error) {
//       _showSnackBar('Failed to fetch current location: $error');
//     }
//   }

//   /// Helper to display a snack bar with a message.
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   /// Date picker for selecting a transaction date.
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

//   /// Add a new transaction to Firebase and call the parent callback.
//   Future<void> _addTransactionToFirebase(model.Transaction transaction) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       await firestore.collection('transactions').add({
//         'merchant': transaction.merchant,
//         'date': transaction.date,
//         'category': transaction.category,
//         'amount': transaction.amount,
//         'description': transaction.description,
//         'location': transaction.location,
//       });
//     } catch (error) {
//       _showSnackBar('Failed to add transaction to Firebase: $error');
//     }
//   }

//   /// Validate and add a new transaction.
//   void _addTransaction() {
//     if (_formKey.currentState!.validate() &&
//         _selectedDate != null &&
//         _selectedLocation != null) {
//       final newTransaction = model.Transaction(
//         merchant: _merchantController.text,
//         date:
//             '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
//         category: _selectedCategory!,
//         amount: double.parse(_amountController.text),
//         description: _descriptionController.text,
//         location: _selectedLocation!,
//       );

//       widget.onAddTransaction(newTransaction);
//       _addTransactionToFirebase(newTransaction);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('New transaction added')),
//       );

//       Navigator.pop(context);
//     } else {
//       if (_selectedDate == null) {
//         _showSnackBar('Please select a date');
//       } else if (_selectedLocation == null) {
//         _showSnackBar('Please select a location');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'New Transaction',
//           style: TextStyle(
//             color: Color(0xFF0093FF),
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Color(0xFF0093FF)),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildCalendarButton(),
//                 const SizedBox(height: 16.0),
//                 _buildLocationDropdown(),
//                 const SizedBox(height: 16.0),
//                 _buildFormFields(),
//                 const SizedBox(height: 16.0),
//                 _buildActionButtons(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Builds the calendar button for date selection.
//   Widget _buildCalendarButton() {
//     return GestureDetector(
//       onTap: _pickDate,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.calendar_today,
//             color: Color(0xFF0093FF),
//             size: 30,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             _selectedDate == null
//                 ? 'Select Date'
//                 : '${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}',
//             style: const TextStyle(color: Color(0xFF0093FF)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationDropdown() {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: CrossAxisAlignment.center, // Center the icon horizontally
//     children: [
//       IconButton(
//         icon: const Icon(Icons.location_on, color: Color(0xFF0093FF)),
//         onPressed: () {
//           setState(() {
//             _showDropdown = !_showDropdown;
//           });
//         },
//       ),
//       if (_showDropdown)
//         DropdownButtonFormField<String>(
//           items: _recommendedLocations
//               .map((location) => DropdownMenuItem(
//                     value: location,
//                     child: Text(location),
//                   ))
//               .toList(),
//           onChanged: (value) async {
//             if (value == "Current Location") {
//               await _getCurrentLocation();
//             } else {
//               setState(() {
//                 _selectedLocation = value;
//               });
//             }
//           },
//             hint: const Text(
//               'Select a location',
//               style: TextStyle(
//               color: Color.fromARGB(255, 189, 189, 189),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//               ),
//             ),
//         ),
//     ],
//   );
// }

//   /// Builds the transaction form fields.
//   Widget _buildFormFields() {
//     return Column(
//       children: [
//         TextFormField(
//           controller: _merchantController,
//           decoration: const InputDecoration(
//             hintText: 'Merchant',
//             hintStyle: TextStyle(
//               color: Color.fromARGB(255, 189, 189, 189),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter the merchant';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16.0),

//         DropdownButtonFormField<String>(
//           value: _selectedCategory,
//           items: ['Food', 'Bill', 'Income']
//             .map(
//               (category) => DropdownMenuItem(
//                 value: category,
//                 child: Text(category),
//               ),
//             )
//             .toList(),
//           onChanged: (value) {
//             setState(() {
//               _selectedCategory = value;
//             });
//           },
//           decoration: const InputDecoration(
//             hintText: 'Category',
//             hintStyle: TextStyle(
//               color: Color.fromARGB(255, 189, 189, 189),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             ),            
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select a category';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16.0),

//         TextFormField(
//           controller: _amountController,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             hintText: 'Amount',
//             hintStyle: TextStyle(
//               color: Color.fromARGB(255, 189, 189, 189),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             ),            
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter the amount';
//             }
//             if (double.tryParse(value) == null) {
//               return 'Please enter a valid amount';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 16.0),

//         TextFormField(
//           controller: _descriptionController,
//           decoration: const InputDecoration(
//             hintText: 'Description',
//             hintStyle: TextStyle(
//               color: Color.fromARGB(255, 189, 189, 189),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             ),            
//           ),
//           validator: (value) {
//             if (value!.length > 50) {
//               return 'No more than 50 characters';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   /// Builds action buttons for form submission or cancellation.
//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.grey[300],
//           ),
//           child: const Text(
//             'Cancel',
//             style: TextStyle(color: Color(0xFF0093FF)),
//           ),
//         ),
//         ElevatedButton(
//           onPressed: _addTransaction,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF0093FF),
//           ),
//           child: Text('Add', style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }
