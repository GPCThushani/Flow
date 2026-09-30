import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flow/providers/auth_provider.dart';
import 'package:flow/providers/expense_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getUserName(UserAuthProvider auth) {
    if (auth.user?.displayName != null && auth.user!.displayName!.isNotEmpty) {
      return auth.user!.displayName!;
    }
    final email = auth.user?.email ?? 'User';
    return email.split('@')[0];
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food': return const Color(0xFFF4B400); 
      case 'transport': return const Color(0xFF5F806F); 
      case 'shopping': return const Color(0xFFE57373); 
      case 'bills': return const Color(0xFF64B5F6); 
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Icons.restaurant;
      case 'transport': return Icons.directions_car;
      case 'shopping': return Icons.shopping_bag;
      case 'bills': return Icons.receipt;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);

    return Scaffold(
      body: SafeArea(
        child: expenseProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  expenseProvider.updateUser(authProvider.user?.uid);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()},',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                              ),
                              Text(
                                _getUserName(authProvider),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // Profile Navigation Icon
                          CircleAvatar(
                            // ignore: deprecated_member_use
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: IconButton(
                              icon: Icon(Icons.person, color: primaryColor),
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Total Spending Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'This Month',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currencyFormat.format(expenseProvider.currentMonthTotal),
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 32, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Dynamic Chart Section
                      const Text('Spending by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (expenseProvider.categoryBreakdown.isEmpty)
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const Text('No expenses yet this month.', style: TextStyle(color: Colors.grey)),
                        )
                      else
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 50,
                              sections: expenseProvider.categoryBreakdown.entries.map((entry) {
                                return PieChartSectionData(
                                  color: _getCategoryColor(entry.key),
                                  value: entry.value,
                                  title: '', 
                                  radius: 30,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),

                      // Recent Expenses List
                      const Text('Recent Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (expenseProvider.expenses.isEmpty)
                        const Center(child: Text('No recent expenses', style: TextStyle(color: Colors.grey)))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expenseProvider.expenses.length > 5 ? 5 : expenseProvider.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenseProvider.expenses[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                // ignore: deprecated_member_use
                                backgroundColor: _getCategoryColor(expense.category).withOpacity(0.15),
                                child: Icon(_getCategoryIcon(expense.category), color: _getCategoryColor(expense.category)),
                              ),
                              title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                '${DateFormat('MMM dd').format(expense.date)} • ${expense.category}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                currencyFormat.format(expense.amount),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
      
     