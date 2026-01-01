import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required String id,
    required String userId,
    required String type,
    required double amount,
    required String category,
    required String description,
    required DateTime transactionDate,
  }) : super(
         id: id,
         userId: userId,
         type: type,
         amount: amount,
         category: category,
         description: description,
         transactionDate: transactionDate,
       );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'transaction_date': transactionDate.toIso8601String(),
    };
  }
}
