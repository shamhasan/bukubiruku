import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/transaction/domain/entities/transaction.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';
import 'package:money_tracker_app/transaction/presentation/screen/edit_transaction_screen.dart';
import 'package:money_tracker_app/transaction/presentation/screen/home_screen.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? _selectedFilter;

  List<Transaction> _getFilteredTransactions(
    List<Transaction> allTransactions,
  ) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Hari':
        return allTransactions.where((t) {
          final tDate = t.transactionDate;
          return tDate.year == now.year &&
              tDate.month == now.month &&
              tDate.day == now.day;
        }).toList();
      case 'Minggu':
        final today = DateTime(now.year, now.month, now.day);
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return allTransactions.where((t) {
          return !t.transactionDate.isBefore(startOfWeek);
        }).toList();
      case 'Bulan':
        return allTransactions.where((t) {
          return t.transactionDate.year == now.year &&
              t.transactionDate.month == now.month;
        }).toList();
      case 'Tahun':
        return allTransactions.where((t) {
          return t.transactionDate.year == now.year;
        }).toList();
      default:
        return allTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light grey background
      appBar: AppBar(
        title: const Text('Detail Screen'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer(
        builder: (context, TransactionProvider transactionProvider, _) {
          final allTransactions = transactionProvider.transactions;
          final filteredTransactions = _getFilteredTransactions(
            allTransactions,
          );

          double filteredincome = 0;
          double filteredexpense = 0;
          for (var transaction in filteredTransactions) {
            if (transaction.type.toString() == "income") {
              filteredincome += transaction.amount;
            } else if (transaction.type.toString() == "expense") {
              filteredexpense += transaction.amount;
            }
          }
          final double periodBalanced = filteredincome - filteredexpense;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16,
                  ),
                  width: double.infinity,
                  height: 400,
                  child: Stack(
                    children: [
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _filterButton("Hari"),
                                  _filterButton("Minggu"),
                                  _filterButton("Bulan"),
                                  _filterButton("Tahun"),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                child: Container(
                                  height: 200,
                                  child: Consumer<AuthProvider>(
                                    builder:
                                        (
                                          BuildContext context,
                                          AuthProvider auth,
                                          Widget? child,
                                        ) {
                                          return PieChartTransaction(
                                            context,
                                            periodBalanced,
                                            filteredexpense,
                                            filteredincome,
                                          );
                                        },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    PieChartIndicator(
                                      title: "Pemasukan",
                                      color: Colors.green,
                                    ),
                                    PieChartIndicator(
                                      title: "Pengeluaran",
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Recent Transactions",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Consumer<TransactionProvider>(
                          builder:
                              (
                                BuildContext context,
                                TransactionProvider transactionProvider,
                                Widget? child,
                              ) {
                                if (filteredTransactions.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      height: 250,
                                      child: Center(
                                        child: Text(
                                          "No transactions available.",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  itemCount: filteredTransactions.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditTransactionScreen(
                                                transaction:
                                                    filteredTransactions[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      leading: LeadingIcon(
                                        type: filteredTransactions[index].type,
                                        category: filteredTransactions[index]
                                            .category,
                                      ),
                                      title: Text(
                                        filteredTransactions[index].description,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      subtitle: Text(
                                        _formatDate(
                                          filteredTransactions[index]
                                              .transactionDate,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            filteredTransactions[index].type
                                                        .toString() ==
                                                    "expense"
                                                ? "-Rp${_formatNumber(filteredTransactions[index].amount)}"
                                                : "Rp${_formatNumber(filteredTransactions[index].amount)}",
                                            style: TextStyle(
                                              color:
                                                  filteredTransactions[index]
                                                          .type
                                                          .toString() ==
                                                      "expense"
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            (filteredTransactions[index]
                                                        .category)[0]
                                                    .toUpperCase() +
                                                (filteredTransactions[index]
                                                        .category)
                                                    .substring(1)
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                );
                              },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(double? value) {
    if (value == null) return "0";
    final numberString = value.truncate().toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return numberString.replaceAllMapped(reg, (Match match) => '${match[1]}.');
  }

  Widget _buildCurrencyText(double amount, double scale) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Rp",
            style: TextStyle(
              fontSize: 24 * scale,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          TextSpan(
            text: _formatNumber(amount),
            style: TextStyle(
              fontSize: 32 * scale,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget PieChartTransaction(
    BuildContext context,
    double balance,
    double expense,
    double income,
  ) {
    final total = income + expense;

    double incomePercentage = total == 0 ? 0 : (income / total) * 100;
    double expensePercentage = total == 0 ? 0 : (expense / total) * 100;
    return Stack(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Uang: ",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              _buildCurrencyText(balance, 0.5),
            ],
          ),
        ),
        PieChart(
          curve: Curves.bounceInOut,
          PieChartData(
            sections: [
              PieChartSectionData(
                value: incomePercentage,
                radius: 20,
                color: Colors.green,
                title: '',
              ),
              PieChartSectionData(
                value: expensePercentage,
                radius: 20,
                color: Colors.red,
                title: '',
              ),
            ],
            sectionsSpace: 3,
            startDegreeOffset: 0,
          ),
        ),
      ],
    );
  }

  OutlinedButton _filterButton(String title) {
    bool _isSelected = _selectedFilter == title;
    List<Transaction> filteredTransactions;
    final now = DateTime.now();

    final allTransactions = Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).transactions;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: _isSelected ? Colors.blueAccent : Colors.transparent,
        foregroundColor: _isSelected ? Colors.white : Colors.grey,
        side: BorderSide(
          color: _isSelected ? Colors.blueAccent : Colors.grey,
          width: 1.5,
        ),
      ),
      onPressed: () {
        setState(() {
          if (_selectedFilter != title) {
            _selectedFilter = title;
          } else {
            _selectedFilter = null;
          }
        });
      },
      child: Center(child: Text(title)),
    );
  }
}

class PieChartIndicator extends StatelessWidget {
  PieChartIndicator({super.key, required this.title, required this.color});
  String title;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  final localDate = date;
  const List<String> days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];
  const List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final dayName = days[localDate.weekday - 1];
  final monthName = months[localDate.month - 1];
  final hour = localDate.hour.toString().padLeft(2, '0');
  final minute = localDate.minute.toString().padLeft(2, '0');

  return '$dayName, ${localDate.day} $monthName ${localDate.year} $hour:$minute';
}
