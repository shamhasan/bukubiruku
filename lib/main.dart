import 'package:flutter/material.dart';
import 'package:money_tracker_app/auth/presentation/widget/auth_gate.dart';
import 'package:money_tracker_app/transaction/data/datasource/receipt_scanner_service.dart';
import 'package:money_tracker_app/transaction/domain/use_case/scan_receipt.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:money_tracker_app/auth/data/datasource/user_remote_datasource.dart';
import 'package:money_tracker_app/auth/data/repository_implementation/user_repository_implementation.dart';
import 'package:money_tracker_app/auth/domain/repository_interface/user_repository.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/transaction/data/datasource/transaction_remote_datasource.dart';
import 'package:money_tracker_app/transaction/data/repository_implementation/transaction_repository_implementation.dart';
import 'package:money_tracker_app/transaction/domain/repository_interface/transaction_repository.dart';
import 'package:money_tracker_app/transaction/domain/use_case/add_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/delete_transaction.dart';
import 'package:money_tracker_app/transaction/domain/use_case/get_transactions.dart';
import 'package:money_tracker_app/transaction/domain/use_case/update_transaction.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iabcqsuuahaduhkcqmyl.supabase.co',
    anonKey: 'sb_publishable_uAJuBcp1eRTkrnR_nwSsaQ__mG2SgDn',
  );

  final client = Supabase.instance.client;

  runApp(
    MultiProvider(
      providers: [
        // DATASOURCES
        Provider<UserRemoteDatasource>(
          create: (_) => UserRemoteDatasource(client: client),
        ),
        Provider<TransactionRemoteDatasource>(
          create: (_) => TransactionRemoteDatasource(client: client),
        ),
        Provider<ReceiptScannerService>(
          create: (_) => ReceiptScannerService(),
        ),
        // REPOSITORIES
        Provider<UserRepository>(
          create: (context) => UserRepositoryImplementation(
            remoteDatasource: context.read<UserRemoteDatasource>(),
          ),
        ),
        Provider<TransactionRepository>(
          create: (context) => TransactionRepositoryImplementation(
            remoteDatasource: context.read<TransactionRemoteDatasource>(),
            scannerService: context.read<ReceiptScannerService>(),
          ),
        ),

        // USECASES (Transaction)
        Provider<GetTransactions>(
          create: (context) => GetTransactions(
            repository: context.read<TransactionRepository>(),
          ),
        ),
        Provider<AddTransaction>(
          create: (context) =>
              AddTransaction(repository: context.read<TransactionRepository>()),
        ),
        Provider<UpdateTransaction>(
          create: (context) => UpdateTransaction(
            repository: context.read<TransactionRepository>(),
          ),
        ),
        Provider<DeleteTransaction>(
          create: (context) => DeleteTransaction(
            repository: context.read<TransactionRepository>(),
          ),
        ),
        Provider<ScanReceipt>(
          create: (context) => ScanReceipt(
            repository: context.read<TransactionRepository>(),
          ),
        ),

        // PROVIDERS
        ChangeNotifierProvider(
          create: (context) =>
              AuthProvider(repository: context.read<UserRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(
            getTransactionsUseCase: context.read<GetTransactions>(),
            addTransactionUseCase: context.read<AddTransaction>(),
            updateTransactionUseCase: context.read<UpdateTransaction>(),
            deleteTransactionUseCase: context.read<DeleteTransaction>(),
            scanReceiptUseCase: context.read<ScanReceipt>(),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
  //  MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
