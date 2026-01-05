import 'package:money_tracker_app/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String email,
    required String userName,
    required double balance,
    required double totalIncome,
    required double totalExpense,
  }) : super(
         id: id,
         email: email,
         userName: userName,
         balance: balance,
         totalIncome: totalIncome,
         totalExpense: totalExpense,
       );

  factory UserModel.fromSupabase(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      userName: user.userMetadata?['username'] ?? '',
      balance: user.userMetadata?['balance']?.toDouble() ?? 0.0,
      totalIncome: user.userMetadata?['total_income']?.toDouble() ?? 0.0,
      totalExpense: user.userMetadata?['total_expense']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': userName,
      'balance': balance,
      'total_income': totalIncome,
      'total_expense': totalExpense,
    };
  }
}
