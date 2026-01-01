
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class Login {
  final UserRepository repository;
  Login({required this.repository});

  Future execute(String email, String password) {
    return repository.login(email, password);
  }  
}