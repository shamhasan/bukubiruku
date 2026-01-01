import 'package:flutter/material.dart';
import 'package:money_tracker_app/auth/domain/entities/user_entity.dart';
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository repository;

  AuthProvider({required this.repository});

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await repository.getCurrentUser();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserEntity> login(String email, String password) async {
    final user = await repository.login(email, password);
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<UserEntity> register(
    String email,
    String userName,
    String password,
  ) async {
    final user = await repository.register(email, userName, password);
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<void> logout() async {
    await repository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateAmount(String userId, double balance, double totalIncome, double totalExpense) async {
    await repository.updateAmount(userId, balance, totalIncome, totalExpense);
    
    await loadCurrentUser();
  }
}
