import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/auth/presentation/widget/auth_gate.dart';
import 'package:money_tracker_app/injection_container.dart' as di;
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
  );

  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<TransactionProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
      ],
      child: MaterialApp(
        title: "BukuBiruKu",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme(textTheme)),
        home: AuthGate(),
      ),
    );
  }
}
