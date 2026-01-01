import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class UpdateAmount {
  final UserRepository repository;

  UpdateAmount({required this.repository});
  Future<void> execute(String userId, double balance, double totalIncome, double totalExpense) {
    return repository.updateAmount(userId, balance, totalIncome, totalExpense);
  }

}