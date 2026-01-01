import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:money_tracker_app/transaction/data/datasource/category.dart';
import 'package:money_tracker_app/transaction/data/datasource/type.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';
import 'package:money_tracker_app/transaction/presentation/screen/add_transaction_screen.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;
  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _typeString;
  String? _categoryString;

  @override
  void initState() {
    super.initState();
    _jumlahController.text = widget.transaction.amount.toInt().toString();
    _deskripsiController.text = widget.transaction.description;
    _categoryString = widget.transaction.category;
    _typeString =
        widget.transaction.type[0].toUpperCase() +
        widget.transaction.type.substring(1).toLowerCase();
  }

  TransactionProvider get transactionP =>
      Provider.of<TransactionProvider>(context, listen: false);

  AuthProvider get authP => Provider.of<AuthProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _deskripsiController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _jumlahController,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _typeString,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    items: [
                      for (var type in transactionTypes)
                        DropdownMenuItem(value: type, child: Text(type)),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _typeString = value;
                        _categoryString = null;
                        print(_typeString);
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _categoryString,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    items: _typeString == 'Expense'
                        ? [
                            for (var type in expenseTransactionCategories)
                              DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type[0].toUpperCase() + type.substring(1),
                                ),
                              ),
                          ]
                        : [
                            for (var type in incomeTransactionCategories)
                              DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type[0].toUpperCase() + type.substring(1),
                                ),
                              ),
                          ],
                    onChanged: (String? value) {
                      setState(() {
                        _categoryString = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green[100],
                    ),
                    onPressed: () {
                      if (_typeString == null ||
                          _categoryString == null ||
                          _jumlahController.text.isEmpty ||
                          _deskripsiController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lengkapi semua informasi'),
                          ),
                        );
                        return;
                      }

                      final Transaction transaction = Transaction(
                        id: widget.transaction.id,
                        userId: authP.currentUser?.id ?? '',
                        description: _deskripsiController.text,
                        amount:
                            double.tryParse(
                              _jumlahController.text.replaceAll(".", ""),
                            ) ??
                            0,
                        type: (_typeString ?? '').toLowerCase(),
                        category: _categoryString ?? '',
                        transactionDate: DateTime.now(),
                      );

                      if (widget.transaction.type == 'income') {
                        authP.currentUser?.balance -= widget.transaction.amount;
                        authP.currentUser?.totalIncome -=
                            widget.transaction.amount;
                      } else {
                        authP.currentUser?.balance += widget.transaction.amount;
                        authP.currentUser?.totalExpense -=
                            widget.transaction.amount;
                      }

                      if (transaction.type == 'income') {
                        authP.currentUser?.balance += transaction.amount;
                        authP.currentUser?.totalIncome += transaction.amount;
                      } else {
                        authP.currentUser?.balance -= transaction.amount;
                        authP.currentUser?.totalExpense += transaction.amount;
                      }

                      transactionP.updateTransaction(transaction);
                      if (mounted) {
                        authP.updateAmount(
                          authP.currentUser!.id,
                          authP.currentUser!.balance,
                          authP.currentUser!.totalIncome,
                          authP.currentUser!.totalExpense,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transaction updated successfully'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Edit Transaksi',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
