import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/transaction.dart';

part 'transaction_state.dart';

// class TransactionCubit extends Cubit<TransactionState> {
//   TransactionCubit() : super(TransactionInitial());
// }

class TransactionsCubit extends Cubit<TransactionState> {
  final List<Transaction> _allTransactions;


  TransactionsCubit(this._allTransactions) : super(TransactionInitial()) {

    emit(TransactionLoaded(_allTransactions));
  }

  // Filter by search query
  void filterByQuery(String query) {
    final filtered = _allTransactions
        .where((transaction) =>
            transaction.merchant.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(TransactionLoaded(filtered));
  }

  // Filter by a specific date
  void filterByDate(DateTime date) {
    final filtered = _allTransactions.where((transaction) {
      final transactionDate = DateTime.parse(transaction.date);
      return transactionDate.year == date.year &&
          transactionDate.month == date.month &&
          transactionDate.day == date.day;
    }).toList();
    emit(TransactionLoaded(filtered));
  }

  // Filter by category
  void filterByCategory(String category) {
    final filtered = _allTransactions
        .where((transaction) => transaction.category == category)
        .toList();
    emit(TransactionLoaded(filtered));
  }

  // Reset all filters to show all transactions
  void resetFilters() {
    emit(TransactionLoaded(_allTransactions));
  }

  void removeTransaction(Transaction transaction) {
    _allTransactions.remove(transaction);  // Remove transaction from the list
    emit(TransactionLoaded(List.from(_allTransactions))); // Emit updated list
  }
}
