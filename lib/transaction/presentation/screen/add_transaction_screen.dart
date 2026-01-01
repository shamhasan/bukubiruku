import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:money_tracker_app/transaction/data/datasource/category.dart';
import 'package:money_tracker_app/transaction/data/datasource/type.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _typeString;
  String? _categoryString;

  TransactionProvider get transactionP =>
      Provider.of<TransactionProvider>(context, listen: false);

  AuthProvider get authP => Provider.of<AuthProvider>(context, listen: false);

  Future<void> _handleScanImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      if (!mounted) {
        return;
      }
      final provider = context.read<TransactionProvider>();
      try {
        final Transaction? scannedReceipt = await provider.scanReceipt(
          File(image.path),
        );

        if (scannedReceipt != null && mounted) {
          setState(() {
            _jumlahController.text = scannedReceipt.amount.toInt().toString();
            _deskripsiController.text = scannedReceipt.description;
            _typeString =
                scannedReceipt.type[0].toUpperCase() +
                scannedReceipt.type.substring(1);
            _categoryString = scannedReceipt.category;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota berhasil dipindai')),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Gagal memindai nota')));
        }
      }  catch (e) {
        if (mounted) {
          String errorMessage = 'Terjadi kesalahan: $e';
          if (e.toString().contains('Quota exceeded')) {
            errorMessage =
                'Kuota AI habis atau model tidak tersedia. Coba ganti model AI.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Consumer<TransactionProvider>(
            builder:
                (
                  BuildContext context,
                  TransactionProvider transactionProvider,
                  Widget? child,
                ) {
                  return Stack(
                    children: [
                      Card(
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
                                  labelText: 'Deskripsi Transaksi',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _jumlahController,
                                decoration: const InputDecoration(
                                  labelText: 'Jumlah (Rp)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  label: const Text('Tipe Transaksi'),
                                ),
                                items: [
                                  for (var type in transactionTypes)
                                    DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  label: const Text('Kategori'),
                                ),
                                items: _typeString == 'Expense'
                                    ? [
                                        for (var type
                                            in expenseTransactionCategories)
                                          DropdownMenuItem(
                                            value: type,
                                            child: Text(
                                              type[0].toUpperCase() +
                                                  type.substring(1),
                                            ),
                                          ),
                                      ]
                                    : [
                                        for (var type
                                            in incomeTransactionCategories)
                                          DropdownMenuItem(
                                            value: type,
                                            child: Text(
                                              type[0].toUpperCase() +
                                                  type.substring(1),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: Colors.green[100],
                                  ),
                                  onPressed: () async {
                                    if (_typeString == null ||
                                        _categoryString == null ||
                                        _jumlahController.text.isEmpty ||
                                        _deskripsiController.text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Lengkapi semua informasi',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final Transaction transaction = Transaction(
                                      id: Uuid().v4(),
                                      userId: authP.currentUser?.id ?? '',
                                      description: _deskripsiController.text,
                                      amount:
                                          double.tryParse(
                                            _jumlahController.text.replaceAll(
                                              '.',
                                              '',
                                            ),
                                          ) ??
                                          0,
                                      type: (_typeString ?? '').toLowerCase(),
                                      category: _categoryString ?? '',
                                      transactionDate: DateTime.now(),
                                    );

                                    authP.currentUser?.balance +=
                                        transaction.type == 'income'
                                        ? transaction.amount
                                        : -transaction.amount;

                                    authP.currentUser?.totalExpense +=
                                        transaction.type == 'expense'
                                        ? transaction.amount
                                        : 0;

                                    authP.currentUser?.totalIncome +=
                                        transaction.type == 'income'
                                        ? transaction.amount
                                        : 0;

                                    final transactionSuccess =
                                        await transactionP.addTransaction(
                                          transaction,
                                        );

                                    if (transactionSuccess) {
                                      await authP.updateAmount(
                                        authP.currentUser!.id,
                                        authP.currentUser!.balance,
                                        authP.currentUser!.totalIncome,
                                        authP.currentUser!.totalExpense,
                                      );
                                      Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Gagal menambahkan transaksi',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                  },
                                  child: Text(
                                    'Tambah Transaksi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Poppins",
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 8,
                                  right: 8,
                                  left: 8,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: Colors.blue[100],
                                  ),
                                  onPressed: () {
                                    _handleScanImage();
                                  },
                                  child: Text(
                                    "Ambil Gambar",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (transactionProvider.isScanning)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  Text(
                                    "Memproses data...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
          ),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final numberString = newValue.text.replaceAll('.', '');
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = numberString.replaceAllMapped(
      reg,
      (Match match) => '${match[1]}.',
    );

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
