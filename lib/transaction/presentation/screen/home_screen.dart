import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_tracker_app/auth/presentation/provider/auth_provider.dart';
import 'package:money_tracker_app/auth/presentation/screens/profile_screen.dart';
import 'package:money_tracker_app/transaction/presentation/providers/transaction_provider.dart';
import 'package:money_tracker_app/transaction/presentation/screen/add_transaction_screen.dart';
import 'package:money_tracker_app/transaction/presentation/screen/detail_screen.dart';
import 'package:money_tracker_app/transaction/presentation/screen/edit_transaction_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  static final List<Widget> _page = [
    const HomeScreenContent(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _page[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 10, // Seberapa lembut bayangannya
                offset: const Offset(0, 4), // Posisi bayangan (x, y)
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 8,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvier = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );

      transactionProvider.setUserId(authProvier.currentUser?.id);
      transactionProvider.fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<TransactionProvider>(context).isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider authProvider, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hi, ${authProvider.currentUser?.userName}!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.notifications_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      color: Colors.orange[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Balance",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DetailScreen();
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "View Details",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,

                                              color: Colors.blue,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                _buildCurrencyText(
                                  authProvider.currentUser?.balance ?? 0,
                                  1.2,
                                ),
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Incomes",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        _buildCurrencyText(
                                          authProvider
                                                  .currentUser
                                                  ?.totalIncome ??
                                              0,
                                          0.5,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Expenses",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,

                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        _buildCurrencyText(
                                          authProvider
                                                  .currentUser
                                                  ?.totalExpense ??
                                              0,
                                          0.5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Card(
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
                                    final transactions =
                                        transactionProvider.transactions;
                                    if (transactions.isEmpty) {
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
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: transactions.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return EditTransactionScreen(
                                                    transaction:
                                                        transactions[index],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          leading: LeadingIcon(
                                            type: transactions[index].type,
                                            category:
                                                transactions[index].category,
                                          ),
                                          title: Text(
                                            transactions[index].description,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            _formatDate(
                                              transactions[index]
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
                                                transactions[index].type
                                                            .toString() ==
                                                        "expense"
                                                    ? "-Rp${_formatNumber(transactions[index].amount)}"
                                                    : "Rp${_formatNumber(transactions[index].amount)}",
                                                style: TextStyle(
                                                  color:
                                                      transactions[index].type
                                                              .toString() ==
                                                          "expense"
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                (transactions[index]
                                                            .category)[0]
                                                        .toUpperCase() +
                                                    (transactions[index]
                                                            .category)
                                                        .substring(1)
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,

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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LeadingIcon extends StatelessWidget {
  const LeadingIcon({super.key, required this.type, required this.category});

  final String type;
  final String category;

  @override
  Widget build(BuildContext context) {
    if (type == "expense") {
      switch (category) {
        case 'Makan & Minum':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.dinner_dining, color: Colors.orange),
          );
        case 'Transportasi':
          return CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Icon(Icons.directions_car, color: Colors.green),
          );
        case 'pendidikan':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.school, color: Colors.orange),
          );
        case 'belanja':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.trolley, color: Colors.orange),
          );
        case 'tagihan & data':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.school, color: Colors.orange),
          );
        case 'kos':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.house_rounded, color: Colors.orange),
          );
        case 'hiburan':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.games_rounded, color: Colors.orange),
          );
        case 'kesehatan':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.medical_services_rounded, color: Colors.orange),
          );
        case 'lainnya':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.donut_large, color: Colors.orange),
          );
        default:
          return CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.attach_money, color: Colors.grey),
          );
      }
    } else if (type == "income") {
      switch (category) {
        case 'gaji':
          return CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Icon(Icons.monetization_on, color: Colors.green),
          );
        case 'bonus':
          return CircleAvatar(
            backgroundColor: Colors.purple[100],
            child: Icon(Icons.card_giftcard, color: Colors.purple),
          );
        case 'hadiah':
          return CircleAvatar(
            backgroundColor: Colors.pink[100],
            child: Icon(Icons.redeem, color: Colors.pink),
          );
        case 'penjualan':
          return CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.store, color: Colors.orange),
          );
        case 'investasi':
          return CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.trending_up, color: Colors.blue),
          );
        case 'lainnya':
          return CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.attach_money, color: Colors.grey),
          );
        default:
          return CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.attach_money, color: Colors.grey),
          );
      }
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.attach_money, color: Colors.grey),
      );
    }
  }
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
          style: TextStyle(fontSize: 24 * scale, fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: _formatNumber(amount),
          style: TextStyle(fontSize: 32 * scale, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
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
