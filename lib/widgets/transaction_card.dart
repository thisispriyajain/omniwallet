import 'package:flutter/material.dart';
import '../model/transaction.dart';


class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSpending = transaction.amount < 0;

    return Dismissible(
      key: Key(transaction.merchant + transaction.date),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF0093FF), width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchant,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color(0xFF0093FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    transaction.date,
                    style:  Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${isSpending ? '- ' : '+ '}\$${transaction.amount.abs().toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSpending ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.arrow_forward_ios, size: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
