import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  Map<String, double> transactionData = {};
  bool isLoading = true;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  Future<void> _fetchTransactionData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('transactions').get();
      Map<String, double> data = {};
      for (var doc in snapshot.docs) {
        final category = doc['category'] as String;
        final amount = (doc['amount'] as num).toDouble();

        if (amount < 0) {
          if (data.containsKey(category)) {
            data[category] = data[category]! + amount; // Accumulate raw negative amounts
          } else {
            data[category] = amount;
          }
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
        title: const Text(
          'OmniWallet',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactionData.isEmpty
              ? const Center(child: Text('No transactions available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Transaction Overview',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions || pieTouchResponse == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection?.touchedSectionIndex ?? -1;
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
                      const Text(
                        'Transaction Breakdown',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 3,
                        child: ListView(
                          children: transactionData.entries.map((entry) {
                            return ListTile(
                              leading: Icon(Icons.category, color: _getCategoryColor(entry.key)),
                              title: Text('${entry.key}: \$${entry.value.toStringAsFixed(2)}'),
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
      case 'Entertainment':
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