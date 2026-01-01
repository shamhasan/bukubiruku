import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction({required this.repository});

  Future<void> execute(String id) {
    return repository.deleteTransaction(id);
  }
}
