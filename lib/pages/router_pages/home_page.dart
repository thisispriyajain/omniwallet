import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BarChartGroupData> barGroups = [];
  Map<String, Map<String, double>> groupedData = {}; // {date: {category: amount}}
  String latestTransactionDate = "";
  double totalMonthlySpending = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSpendingData();
  }

  Future<void> _fetchSpendingData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('transactions').get();
      Map<String, Map<String, double>> tempGroupedData = {};
      double tempTotalSpending = 0.0;
      String tempLatestTransactionDate = "";

      // Process transactions
      for (var doc in snapshot.docs) {
        final date = doc['date'] as String;
        final category = doc['category'] as String;
        final amount = (doc['amount'] as num).toDouble();

        if (amount < 0) {
          // Update grouped data for bar chart
          if (!tempGroupedData.containsKey(date)) {
            tempGroupedData[date] = {};
          }
          tempGroupedData[date]![category] =
              (tempGroupedData[date]![category] ?? 0) + amount.abs();

          // Update total monthly spending
          tempTotalSpending += amount.abs();

          // Update latest transaction date
          if (tempLatestTransactionDate.isEmpty || date.compareTo(tempLatestTransactionDate) > 0) {
            tempLatestTransactionDate = date;
          }
        }
      }

      // Prepare bar chart data
      List<BarChartGroupData> fetchedBarGroups = [];
      int index = 0;
      tempGroupedData.entries.forEach((entry) {
        List<BarChartRodData> rods = [];
        entry.value.entries.forEach((categoryEntry) {
          rods.add(BarChartRodData(
            toY: categoryEntry.value,
            width: 16,
            colors: [_getCategoryColor(categoryEntry.key)],
          ));
        });
        fetchedBarGroups.add(BarChartGroupData(x: index, barRods: rods));
        index++;
      });

      setState(() {
        groupedData = tempGroupedData;
        barGroups = fetchedBarGroups;
        totalMonthlySpending = tempTotalSpending;
        latestTransactionDate = tempLatestTransactionDate;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching spending data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bill':
        return const Color(0xFF0DA5E9);
      case 'Food':
        return const Color(0xFF6CEAC0);
      case 'Entertainment':
        return const Color(0xFF3E3C8D);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OmniWallet',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : barGroups.isEmpty
              ? const Center(child: Text('No transactions available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        color: const Color(0xFF0093FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 80.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Hello, Priya",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "You've spent \$${totalMonthlySpending.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                latestTransactionDate.isNotEmpty
                                    ? latestTransactionDate
                                    : "No transactions",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "Daily Spending",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                getTitles: (value) => value.toInt().toString(),
                                margin: 8,
                                reservedSize: 40,
                              ),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  // Match index to date
                                  if (value.toInt() < groupedData.length) {
                                    final date = groupedData.keys.toList()[value.toInt()];
                                    return date.substring(0, 5); // MM/DD
                                  }
                                  return '';
                                },
                                margin: 8,
                              ),
                            ),
                            barGroups: barGroups,
                            maxY: groupedData.values
                                .expand((e) => e.values)
                                .reduce((a, b) => a > b ? a : b) +
                                10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}