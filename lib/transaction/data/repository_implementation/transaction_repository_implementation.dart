import 'dart:io';

import 'package:money_tracker_app/transaction/data/datasource/receipt_scanner_service.dart';
import 'package:money_tracker_app/transaction/data/datasource/transaction_remote_datasource.dart';
import 'package:money_tracker_app/transaction/data/entities/transaction_model.dart';
import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';

class TransactionRepositoryImplementation implements TransactionRepository {
  final TransactionRemoteDatasource remoteDatasource;
  final ReceiptScannerService scannerService;

  TransactionRepositoryImplementation({
    required this.remoteDatasource,
    required this.scannerService,
  });

  @override
  Future<bool> addTransaction(Transaction transaction) async {
    final transactionModel = TransactionModel(
      id: transaction.id ?? "",
      userId: transaction.userId,
      type: transaction.type,
      amount: transaction.amount,
      category: transaction.category,
      description: transaction.description,
      transactionDate: transaction.transactionDate,
    );

    return await remoteDatasource.addTransaction(transactionModel);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final transactionModel = TransactionModel(
      id: transaction.id ?? "",
      userId: transaction.userId,
      type: transaction.type,
      amount: transaction.amount,
      category: transaction.category,
      description: transaction.description,
      transactionDate: transaction.transactionDate,
    );

    // Tetap void, sesuai permintaan
    await remoteDatasource.updateTransaction(transactionModel);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // Tetap void, sesuai permintaan
    await remoteDatasource.deleteTransaction(id);
  }

  @override
  // SATU-SATUNYA PERUBAHAN PENTING: Tambah parameter userId
  Future<List<Transaction>> getTransactions(String userId) async {
    final transactionModels = await remoteDatasource.getTransaction(userId);
    return List<Transaction>.from(transactionModels);
  }

  @override
  Future<Transaction?> scanReceipt(File image) async {
    final result = await scannerService.scanReceipt(image);

    if (result!=null) {
      return Transaction(
        id: "",
        userId: "",
        type: result['type'] ?? "Expense",
        amount: result['amount'] ?? 0.0,
        category: result['category'] ?? "makan & minum",
        description: result['description'] ?? "Hasil scan",
        transactionDate: result['transactionDate'] ?? DateTime.now(),
      );
    }
    return null;
  }
}
