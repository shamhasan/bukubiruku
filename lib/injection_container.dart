import 'package:get_it/get_it.dart';
import 'package:money_tracker_app/auth/data/datasource/user_remote_datasource.dart';
import 'package:money_tracker_app/auth/data/repository_implementation/user_repository_implementation.dart';
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';
import 'package:money_tracker_app/auth/domain/use_case/checkSessionUseCase.dart';
import 'package:money_tracker_app/auth/domain/use_case/getCurrentUser.dart';
import 'package:money_tracker_app/auth/domain/use_case/login.dart';
import 'package:money_tracker_app/auth/domain/use_case/logout.dart';
import 'package:money_tracker_app/auth/domain/use_case/register.dart';
import 'package:money_tracker_app/auth/domain/use_case/update_amount.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/transaction/data/datasource/receipt_scanner_service.dart';
import 'package:money_tracker_app/transaction/data/datasource/transaction_local_datasource.dart';
import 'package:money_tracker_app/transaction/data/datasource/transaction_remote_datasource.dart';
import 'package:money_tracker_app/transaction/data/repository_implementation/transaction_repository_implementation.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';
import 'package:money_tracker_app/transaction/domain/use_case/add_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/delete_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/get_transactions.dart';
import 'package:money_tracker_app/transaction/domain/use_case/scan_receipt.dart';
import 'package:money_tracker_app/transaction/domain/use_case/update_transaction.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  sl.registerFactory(
    () => AuthProvider(repository: sl(), checkSessionUseCase: sl()),
  );

  sl.registerLazySingleton(() => Register(repository: sl()));
  sl.registerLazySingleton(() => Login(repository: sl()));
  sl.registerLazySingleton(() => Logout(repository: sl()));
  sl.registerLazySingleton(() => UpdateAmount(repository: sl()));
  sl.registerLazySingleton(() => checkSessionUseCase(sl()));
  sl.registerLazySingleton(() => Getcurrentuser(repository: sl()));

  sl.registerLazySingleton(() => AddTransaction(repository: sl()));
  sl.registerLazySingleton(() => GetTransactions(repository: sl()));
  sl.registerLazySingleton(() => UpdateTransaction(repository: sl()));
  sl.registerLazySingleton(() => DeleteTransaction(repository: sl()));
  sl.registerLazySingleton(() => ScanReceipt(repository: sl()));

  sl.registerLazySingleton(() => Supabase.instance.client);

  sl.registerLazySingleton<TransactionRemoteDatasource>(
    () => TransactionRemoteDatasource(client: sl()),
  );

  sl.registerLazySingleton<TransactionLocalDatasource>(
    () => TransactionLocalDatasourceImpl(database: sl()),
  );

  sl.registerLazySingleton<ReceiptScannerService>(
    () => ReceiptScannerService(),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImplementation(
      localDatasource: sl(),
      scannerService: sl(),
    ),
  );

  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasource(client: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImplementation(remoteDatasource: sl()),
  );

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, "bukubiruku.db");

  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
       create table transactions (
          id text primary key,
          user_id text not null,
          type text not null,
          amount real not null,
          description text not null,
          category text not null,
          transaction_date text not null
          )
    ''');
    },
  );
  sl.registerLazySingleton(() => database);
}
