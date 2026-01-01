import 'package:flutter/material.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            child: Container(
              height: 400,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: const Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email'),
                          TextField(
                            decoration: InputDecoration(
                              labelText: authProvider.currentUser?.email,
                              border: const OutlineInputBorder(),
                              enabled: false,
                              labelStyle: const TextStyle(color: Colors.black),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username'),
                          TextField(
                            decoration: InputDecoration(
                              labelText: authProvider.currentUser?.userName,
                              border: const OutlineInputBorder(),
                              enabled: false,
                              labelStyle: const TextStyle(color: Colors.black),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          await context.read<AuthProvider>().logout();
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
