
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class Logout {
  final UserRepository repository;
  Logout({required this.repository});
  
  Future execute() {
    return repository.logout();
  }
}