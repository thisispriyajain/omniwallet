import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BarChartGroupData> barGroups = [];
  Map<String, Map<String, double>> groupedData =
      {}; // {date: {category: amount}}
  String latestTransactionDate = "";
  double totalMonthlySpending = 0.0;
  bool isLoading = true;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchSpendingData();
  }

  Future<void> _fetchSpendingData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("no user exists");
      }
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userSnapshot.exists) {
        userName = userSnapshot['name'] ?? 'Guest';
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .get();
      Map<String, Map<String, double>> tempGroupedData = {};
      double tempTotalSpending = 0.0;
      String tempLatestTransactionDate = "";

      for (var doc in snapshot.docs) {
        final date = doc['date'] as String;
        final category = doc['category'] as String;
        final amount = (doc['amount'] as num).toDouble();

        if (amount != 0) {
          if (!tempGroupedData.containsKey(date)) {
            tempGroupedData[date] = {};
          }
          if (amount < 0) {
            tempGroupedData[date]![category] =
                (tempGroupedData[date]![category] ?? 0) + amount.abs();
            tempTotalSpending += amount.abs();
          } else {
            //for income(positive amounts), add them normally
            tempGroupedData[date]![category] =
                (tempGroupedData[date]![category] ?? 0) + amount;
          }
          if (tempLatestTransactionDate.isEmpty ||
              date.compareTo(tempLatestTransactionDate) > 0) {
            tempLatestTransactionDate = date;
          }
        }
      }

      // Sort the data by date
      final sortedEntries = tempGroupedData.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      List<BarChartGroupData> fetchedBarGroups = [];
      int index = 0;
      for (var entry in sortedEntries) {
        List<BarChartRodData> rods = [];
        for (var categoryEntry in entry.value.entries) {
          rods.add(BarChartRodData(
            toY: categoryEntry.value,
            width: 16,
            colors: [_getCategoryColor(categoryEntry.key)],
          ));
        }
        fetchedBarGroups.add(BarChartGroupData(x: index, barRods: rods));
        index++;
      }

      setState(() {
        groupedData = Map.fromEntries(sortedEntries);
        barGroups = fetchedBarGroups;
        totalMonthlySpending = tempTotalSpending;
        latestTransactionDate = tempLatestTransactionDate;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching spending data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bill':
        return const Color(0xFF0DA5E9);
      case 'Food':
        return const Color(0xFF6CEAC0);
      case 'Income':
        return const Color(0xFF3E3C8D);
      default:
        return Colors.grey;
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
                              Text(
                                "Hello, $userName",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "You've spent \$${totalMonthlySpending.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                latestTransactionDate.isNotEmpty
                                    ? latestTransactionDate
                                    : "No transactions",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        "Daily Spending",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue, fontWeight: FontWeight.bold),
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
                                  if (value.toInt() < groupedData.length) {
                                    final date = groupedData.keys
                                        .toList()[value.toInt()];
                                    return date.substring(0, 5); // MM/DD
                                  }
                                  return '';
                                },
                                margin: 8,
                              ),
                              topTitles: SideTitles(
                                showTitles:
                                    false, // Disable top titles to remove indices
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
