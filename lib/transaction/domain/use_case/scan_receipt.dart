
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';

class ScanReceipt {
  final TransactionRepository repository;

  ScanReceipt({required this.repository});

  Future execute(image) {
    return repository.scanReceipt(image);
  }
}