import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../navigation_bar.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OmniWallet',
          style: TextStyle(color: Color(0xFF0093FF),
          fontSize: 45,
          fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
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
                  sections: [
                    PieChartSectionData(
                      color: const Color(0xFF3E3C8D),
                      value: 40,
                      title: 'Food',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: const Color(0xFF0DA5E9),
                      value: 30,
                      title: 'Bills',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: const Color(0xFF6CEAC0),
                      value: 20,
                      title: 'Savings',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
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
                children: const [
                  ListTile(
                    leading: Icon(Icons.fastfood, color: Color(0xFF3E3C8D)),
                    title: Text('Food: \$200'),
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt, color: Color(0xFF0DA5E9)),
                    title: Text('Bills: \$150'),
                  ),
                  ListTile(
                    leading: Icon(Icons.savings, color: Color(0xFF6CEAC0)),
                    title: Text('Savings: \$100'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}