
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class Register {
  final UserRepository  repository;
  Register({required this.repository});

  Future execute(String email, String userName, String password) {
    return repository.register(email, userName, password);
  }
}