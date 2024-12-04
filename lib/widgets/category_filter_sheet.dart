import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/transaction/cubit/transaction_cubit.dart';

class CategoryFilterSheet extends StatelessWidget {
  const CategoryFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: const Center(
            child: Text(
              'Food',
              style: TextStyle(color: Color(0xFF0093FF)),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            context.read<TransactionsCubit>().filterByCategory('Food');
          },
        ),
        Divider(
          color: const Color(0xFF0093FF).withOpacity(0.2),
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          title: const Center(
            child: Text(
              'Bill',
              style: TextStyle(color: Color(0xFF0093FF)),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            context.read<TransactionsCubit>().filterByCategory('Bill');
          },
        ),
        Divider(
          color: const Color(0xFF0093FF).withOpacity(0.2),
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        ListTile(
          title: const Center(
            child: Text(
              'Income',
              style: TextStyle(color: Color(0xFF0093FF)),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            context.read<TransactionsCubit>().filterByCategory('Income');
          },
        ),
      ],
    );
  }
}
