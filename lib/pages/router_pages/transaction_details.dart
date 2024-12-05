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
        title: Text(
          'Transaction Details',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Color(0xFF0093FF),
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
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSpending ? Colors.red : Colors.green,
              ),
            ),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow(context, 'Merchant', transaction.merchant),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow(context, 'Date', transaction.date),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow(context, 'Category', transaction.category),
            Divider(
              color: const Color(0xFF0093FF).withOpacity(0.2),
              thickness: 1,
            ),
            _buildDetailRow(context, 'Description', transaction.description),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0093FF),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color(0xFF0093FF),
            ),
          ),
        ],
      ),
    );
  }
}