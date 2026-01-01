

import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;
  GetTransactions({required this.repository});

  Future<List<Transaction>> execute(String userId) {
    return repository.getTransactions(userId);
  }
}