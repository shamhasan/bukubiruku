import 'package:money_tracker_app/transaction/data/entities/transaction_model.dart';
import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';


class TransactionRemoteDatasource {
  final SupabaseClient client;
  TransactionRemoteDatasource({required this.client});

  Future<List<TransactionModel>> getTransaction(String userId) async {
    try {
      var query =
          await client
                  .from('transactions')
                  .select()
                  .eq('user_id', userId)
                  .order('transaction_date', ascending: false)
              as List<dynamic>;

      final response = query;

      return response
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<bool> addTransaction(TransactionModel transaction) async {
    final client = Supabase.instance.client;

    try {
      final data = transaction.toJson();
      if (data['id'] == null || data['id'] == "") {
        data['id'] = const Uuid().v4();
      }
      await client.from('transactions').insert(data);
      return true;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final client = Supabase.instance.client;
    try {
      await client
          .from('transactions')
          .update(transaction.toJson())
          .eq('id', transaction.id ?? "");
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final client = Supabase.instance.client;
    try {
      await client.from('transactions').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Future<TransactionModel?> scanReceipt(String imageUrl) async {
    
  //   return null;
  // }
}
