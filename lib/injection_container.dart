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
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  final dbPath = await getDatabasesPath();
  final path = join(dbPath, "bukubiruku.db");

  final database = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
       create table public.transactions (
          id uuid not null default gen_random_uuid (),
          user_id uuid not null,
          type text not null,
          amount numeric not null,
          description text not null,
          category text not null,
          transaction_date timestamp with time zone null default now(),
          constraint transactions_pkey primary key (id),
          constraint transactions_user_id_fkey foreign KEY (user_id) references auth.users (id),
          constraint transactions_type_check check (
            (
              type = any (array['income'::text, 'expense'::text])
            )
          )
        ) TABLESPACE pg_default;
    ''');
    },);
}
