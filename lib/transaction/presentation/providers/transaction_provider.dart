import 'package:flutter/foundation.dart';
import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/add_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/delete_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/get_transactions.dart';
import 'package:money_tracker_app/transaction/domain/use_case/scan_receipt.dart';
import 'package:money_tracker_app/transaction/domain/use_case/update_transaction.dart';


class TransactionProvider extends ChangeNotifier {
  final AddTransaction addTransactionUseCase;
  final GetTransactions getTransactionsUseCase;
  final UpdateTransaction updateTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;

  final ScanReceipt scanReceiptUseCase;

  TransactionProvider({
    required this.addTransactionUseCase,
    required this.getTransactionsUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.scanReceiptUseCase,
  });

  String? _userId;

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  void setUserId(String? id) {
    _userId = id;
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_userId != null) {
        _transactions = await getTransactionsUseCase.execute(_userId!);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _transactions = [];
      rethrow;
    }
  }

  Future<bool> addTransaction(Transaction transaction) async {
    if (_userId == null) {
      throw Exception("User belum login!");
    }
    try {
      _isLoading = true;
      notifyListeners();

      await addTransactionUseCase.execute(transaction);
      await fetchTransactions();
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      _isLoading = true;
      notifyListeners();

      await updateTransactionUseCase.execute(transaction);
      await fetchTransactions();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await deleteTransactionUseCase.execute(id);
      await fetchTransactions();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Transaction?> scanReceipt(dynamic image) async {
    _isScanning = true;
    notifyListeners();
    try {
      final result = await scanReceiptUseCase.execute(image);

      _isScanning = false;
      notifyListeners();

      return result;
    } catch (e) {
      _isScanning = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setFilteredTransactions(List<Transaction> filteredTransactions) async {
    _transactions = filteredTransactions;
    notifyListeners();
  }
}
