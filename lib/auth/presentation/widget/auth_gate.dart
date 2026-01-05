
import 'package:flutter/material.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/auth/presentation/screens/login_screen.dart';
import 'package:money_tracker_app/transaction/presentation/screen/home_screen.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    Future.microtask((){
      context.read<AuthProvider>().checkSession();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder:(context, authProvider, _) {
      if (authProvider.isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        if (authProvider.currentUser != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      }
    });
  }
}