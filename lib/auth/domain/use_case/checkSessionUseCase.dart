import 'package:money_tracker_app/auth/domain/entities/user_entity.dart';
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class checkSessionUseCase {
  final UserRepository repository;

  checkSessionUseCase(this.repository);

  Future<UserEntity?> execute()async{
    return await repository.getCurrentUser();
  }
}
