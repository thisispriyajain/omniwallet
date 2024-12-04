import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: const Color(0xFF0093FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello, Priya",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You've spent \$5,000",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "November 6, 2024",
                      style: TextStyle(
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
              "Your Spending",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      getTitles: (value) {
                        return value.toInt().toString();
                      },
                      margin: 8,
                      reservedSize: 40,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        switch (value.toInt()) {
                          case 0:
                            return '11/4';
                          case 1:
                            return '11/5';
                          case 2:
                            return '11/6';
                          default:
                            return '';
                        }
                      },
                      margin: 8,
                    ),
                  ),
                  barGroups: [
                    makeGroupData(0, 500, 300, 100),
                    makeGroupData(1, 700, 500, 200),
                    makeGroupData(2, 600, 800, 600),
                  ],
                  maxY: 1000,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2,
    double y3,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          width: 16,
          colors: [const Color(0xFF0093FF)],
        ),
        BarChartRodData(
          toY: y2,
          width: 16,
          colors: [const Color(0xFF6CEAC0)],
        ),
        BarChartRodData(
          toY: y3,
          width: 16,
          colors: [const Color(0xFF3E3C8D)],
        ),
      ],
    );
  }
}