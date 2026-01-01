import 'package:supabase_flutter/supabase_flutter.dart';

class UserRemoteDatasource {
  final SupabaseClient client;
  UserRemoteDatasource({required this.client});

  Future<User?> getCurrentUser() async {
    final user = client.auth.currentUser;
    return user;
  }

  Future<User> register(String email, String userName, String password) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': userName,
          'balance': 0,
          'total_income': 0,
          'total_expense': 0,
        },
      );
      return response.user!;
    } on Exception catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user!;
    } on Exception catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  Future<void> updateAmount(
    String userId,
    double balance,
    double totalIncome,
    double totalExpense,
  ) async {
    try {
      final response = await client.auth.updateUser(
        UserAttributes(
          data: {
            'balance': balance,
            'total_income': totalIncome,
            'total_expense': totalExpense,
          },
        ),
      );
    } on Exception catch (e) {
      print("Kamu ada error disini mok: $e");
      throw Exception('Update amount failed: $e');
    }
  }
}
