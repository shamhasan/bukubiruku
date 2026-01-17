import 'package:get_it/get_it.dart';
import 'package:money_tracker_app/transaction/data/datasource/receipt_scanner_service.dart';
import 'package:money_tracker_app/transaction/data/datasource/transaction_remote_datasource.dart';
import 'package:money_tracker_app/transaction/data/repository_implementation/transaction_repository_implementation.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';
import 'package:money_tracker_app/transaction/domain/use_case/add_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/delete_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/get_transactions.dart';
import 'package:money_tracker_app/transaction/domain/use_case/scan_receipt.dart';
import 'package:money_tracker_app/transaction/domain/use_case/update_transaction.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => TransactionProvider(
      addTransactionUseCase: sl(),
      getTransactionsUseCase: sl(),
      updateTransactionUseCase: sl(),
      deleteTransactionUseCase: sl(),
      scanReceiptUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => AddTransaction(repository: sl()));
  sl.registerLazySingleton(() => GetTransactions(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransaction(repository: sl()));
  sl.registerLazySingleton(() => DeleteTransaction(repository: sl()));
  sl.registerLazySingleton(() => ScanReceipt(repository: sl()));

  sl.registerLazySingleton<TransactionRemoteDatasource>(
    () => TransactionRemoteDatasource(client: sl()),
  );

  sl.registerLazySingleton<ReceiptScannerService>(
    () => ReceiptScannerService(),
  );


  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImplementation(
      remoteDatasource: sl(),
      scannerService: sl(),
    ),
  );
}
