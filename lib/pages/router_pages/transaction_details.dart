import 'package:flutter/material.dart';

import '../../model/transaction.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetails({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isSpending = transaction.amount < 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: Color(0xFF0093FF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF0093FF),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${isSpending ? '- ' : '+ '}\$${transaction.amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: isSpending ? Colors.red : Colors.green,
              ),
            ),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow('Merchant', transaction.merchant),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow('Date', transaction.date),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow('Category', transaction.category),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow('Description', transaction.description),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0, 
              fontWeight: FontWeight.bold,
              color: Color(0xFF0093FF),
              ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF0093FF),
            ),
          ),
        ],
      ),
    );
  }
}