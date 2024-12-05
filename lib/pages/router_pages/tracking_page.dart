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

        // Only include positive amounts (spendings)
        if (amount < 0) {
          if (data.containsKey(category)) {
            data[category] = (data[category]! + amount).abs();
          } else {
            data[category] = amount.abs();
          }
        }
      }
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sections: transactionData.entries.map((entry) {
                              final color = _getCategoryColor(entry.key);
                              return PieChartSectionData(
                                color: color,
                                value: entry.value,
                                title: '${entry.key}: \$${entry.value.toStringAsFixed(0)}',
                                radius: 50,
                                titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Transaction Breakdown',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
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
