

import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction({required this.repository});

  Future<bool> execute(Transaction transaction){
    return repository.addTransaction(transaction);
  }
}