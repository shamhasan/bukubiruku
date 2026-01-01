class UserEntity {
  final String id;
  final String email;
  final String userName;
  double balance;
  double totalIncome;
  double totalExpense;

  UserEntity({
    required this.id,
    required this.email,
    required this.userName,
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
  });
}
