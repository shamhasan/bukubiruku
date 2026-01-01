import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction({required this.repository});
  Future<void> execute(Transaction transaction) {
    return repository.updateTransaction(transaction);
  }
}
