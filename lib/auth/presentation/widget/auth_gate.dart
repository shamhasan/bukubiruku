
import 'package:flutter/material.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/auth/presentation/screens/login_screen.dart';
import 'package:money_tracker_app/transaction/presentation/screen/home_screen.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
          // User is logged in, navigate to the main app screen
          return const HomeScreen();
        } else {
          // User is not logged in, navigate to the login screen
          return const LoginScreen();
        }
      }
    });
  }
}