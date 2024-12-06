import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting
import 'package:firebase_auth/firebase_auth.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  Map<String, double> transactionData = {};
  bool isLoading = true;
  int touchedIndex = -1;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  Future<void> _fetchTransactionData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Query query = FirebaseFirestore.instance.collection('transactions');

      if (selectedDateRange != null) {
        // Convert DateTime to string in the MM/dd/yyyy format
        final dateFormat = DateFormat('MM/dd/yyyy');
        final startDate = dateFormat.format(selectedDateRange!.start);
        final endDate = dateFormat.format(selectedDateRange!.end);

        query = query.where('date', isGreaterThanOrEqualTo: startDate);
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("no user exists");
        return;
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .get();
      Map<String, double> data = {};
      for (var doc in snapshot.docs) {
        final category = doc['category'] as String;
        final amount = (doc['amount'] as num).toDouble();

        if (data.containsKey(category)) {
          data[category] = data[category]! + amount; // Add to existing category
        } else {
          data[category] = amount; // Initialize new category with the amount
        }
      }

      // Convert all accumulated amounts to positive for display purposes
      data = data.map((key, value) => MapEntry(key, value.abs()));

      setState(() {
        transactionData = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching transaction data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      setState(() {
        selectedDateRange = pickedRange;
      });
      _fetchTransactionData(); // Re-fetch data with the new date range
    }
  }

  List<PieChartSectionData> showingSections() {
    int index = 0;
    return transactionData.entries.map((entry) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 60 : 50;
      final color = _getCategoryColor(entry.key);
      final section = PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.key}: \$${entry.value.toStringAsFixed(0)}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
      index++;
      return section;
    }).toList();
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactionData.isEmpty
              ? Center(
                  child: Text(
                    'No transactions available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Transaction Overview',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _selectDateRange,
                        child: Text(
                          selectedDateRange == null
                              ? 'Select Date Range'
                              : 'Selected: ${DateFormat('MM/dd/yyyy').format(selectedDateRange!.start)} - ${DateFormat('MM/dd/yyyy').format(selectedDateRange!.end)}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event,
                                  PieTouchResponse? pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection
                                          ?.touchedSectionIndex ??
                                      -1;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 60,
                            sections: showingSections(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Transaction Breakdown',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 3,
                        child: ListView(
                          children: transactionData.entries.map((entry) {
                            return ListTile(
                              leading: Icon(Icons.category,
                                  color: _getCategoryColor(entry.key)),
                              title: Text(
                                  '${entry.key}: \$${entry.value.toStringAsFixed(2)}'),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Income':
        return const Color(0xFF3E3C8D);
      case 'Bill':
        return const Color(0xFF0DA5E9);
      case 'Food':
        return const Color(0xFF6CEAC0);
      default:
        return Colors.grey;
    }
  }
}
