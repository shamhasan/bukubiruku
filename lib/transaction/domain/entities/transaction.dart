class Transaction {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final String category;
  final String description;
  final DateTime transactionDate;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.transactionDate,
  });
}
