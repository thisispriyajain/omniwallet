import 'package:flutter/material.dart';

import '../../navigation_bar.dart';

class TransactionsPage extends StatelessWidget {
    const TransactionsPage({super.key});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OmniWallet',
          style: TextStyle(color: Color(0xFF0093FF),
          fontSize: 45,
          fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Search Field
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF0093FF)),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Color(0xFF0093FF)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFF0093FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFF0093FF), width: 2.0),
                    ),
                  ),
                  style: TextStyle(color: Color(0xFF0093FF)),
                ),
                SizedBox(height: 16.0),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('New Transaction', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0093FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ..._mockTransactions(5),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'This Week',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ..._mockTransactions(40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _mockTransactions(int count) {
    return List.generate(
      count,
      (index) => _buildTransactionItem('Transaction ${index + 1}', '\$${(index + 1) * 10}'),
    );
  }

  Widget _buildTransactionItem(String title, String amount) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF0093FF), width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.0, color: Color(0xFF0093FF)),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0093FF),
            ),
          ),
        ],
      ),
    );
  }
}