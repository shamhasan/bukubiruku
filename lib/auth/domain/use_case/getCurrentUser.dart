import 'package:money_tracker_app/auth/domain/entities/user_entity.dart';
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class Getcurrentuser {
  final UserRepository repository;
  Getcurrentuser({required this.repository});

  Future<UserEntity?> execute() {
    return repository.getCurrentUser();
  }
}