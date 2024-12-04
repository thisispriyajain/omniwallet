part of 'transaction_cubit.dart';

@immutable
sealed class TransactionState {}

final class TransactionInitial extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  TransactionLoaded(this.transactions);
}