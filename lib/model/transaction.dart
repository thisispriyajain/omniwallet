class Transaction {
  final String merchant;
  final String date;
  final String category;
  final double amount;
  final String description;

  Transaction({
    required this.merchant,
    required this.date,
    required this.category,
    required this.amount,
    required this.description,
  });

  static List<Transaction> mockTransactions() {
    return [
      Transaction(
        merchant: 'Amazon',
        date: '2024-11-24',
        category: 'Bill',
        amount: -50.0,
        description: 'Monthly subscription',
      ),
      Transaction(
        merchant: 'Starbucks',
        date: '2024-11-23',
        category: 'Food',
        amount: -12.0,
        description: 'Coffee and snacks',
      ),
      Transaction(
        merchant: 'Freelance',
        date: '2024-11-22',
        category: 'Income',
        amount: 500.0,
        description: 'Payment for project',
      ),
    ];
  }
}
