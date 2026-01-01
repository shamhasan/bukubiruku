import 'dart:io';

import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(String userId);

  Future<bool> addTransaction(Transaction transaction);

  Future<void> updateTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);

  Future<Transaction?> scanReceipt(File image);
}
