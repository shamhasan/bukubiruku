import 'package:money_tracker_app/auth/data/datasource/user_remote_datasource.dart';
import 'package:money_tracker_app/auth/data/entities/user_model.dart';
import 'package:money_tracker_app/auth/domain/entities/user_entity.dart';
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class UserRepositoryImplementation implements UserRepository {
  final UserRemoteDatasource remoteDatasource;
  UserRepositoryImplementation({required this.remoteDatasource});

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userSupabase = await remoteDatasource.getCurrentUser();

    if (userSupabase != null) {
      return UserModel.fromSupabase(userSupabase);
    } else {
      return null;
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    return UserModel.fromSupabase(
      await remoteDatasource.login(email, password),
    );
  }

  @override
  Future<void> logout() {
    return remoteDatasource.logout();
  }

  @override
  Future<UserEntity> register(
    String email,
    String userName,
    String password,
  ) async {
    return UserModel.fromSupabase(
      await remoteDatasource.register(email, userName, password),
    );
  }
  
  @override
  Future<void> updateAmount(String userId, double balance, double totalIncome, double totalExpense) {
    return remoteDatasource.updateAmount(userId, balance, totalIncome, totalExpense);
  }
}
