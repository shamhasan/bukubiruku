import 'package:money_tracker_app/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email,String userName, String password);
  Future<void> logout();
  Future<void> updateAmount(String userId, double balance, double totalIncome, double totalExpense);

}