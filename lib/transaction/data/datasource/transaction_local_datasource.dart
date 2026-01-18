import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import 'package:money_tracker_app/transaction/data/entities/transaction_model.dart';
import 'package:uuid/uuid.dart';

abstract class TransactionLocalDatasource {
  Future<List<TransactionModel>> getTransaction(String userId);
  Future<bool> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDatasourceImpl implements TransactionLocalDatasource {
  final Database database;
  TransactionLocalDatasourceImpl({required this.database});

  @override
  Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      final data = transaction.toJson();
      if (data['id'] == null || data['id'] == "") {
        data['id'] = const Uuid().v4();
      }
      await database.insert(
        "transactions",
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      log("error insert: $e", name: 'TransactionLocalDatasource', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await database.delete("transactions", where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log("error delete: $e", name: 'TransactionLocalDatasource', error: e);
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> getTransaction(String userId) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        "transactions",
      );
      return maps.map((e) => TransactionModel.fromJson(e)).toList();
    } catch (e) {
      log("error get: $e", name: 'TransactionLocalDatasource', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await database.update(
        "transactions",
        transaction.toJson(),
        where: "id = ?",
        whereArgs: [transaction.id],
      );
    } catch (e) {
      log("error update: $e", name: 'TransactionLocalDatasource', error: e);
    }
  }
}
