import 'package:flow/core/theme/widgets/state_widgets.dart';
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
  DateTime _selectedMonth = DateTime.now();

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + offset);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
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
      case 'health': return const Color(0xFF81C784);
      case 'entertainment': return const Color(0xFFBA68C8);
      default: return Colors.grey;
    }
  }
 
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Icons.restaurant;
      case 'transport': return Icons.directions_car;
      case 'shopping': return Icons.shopping_bag;
      case 'bills': return Icons.receipt;
      case 'health': return Icons.medical_services;
      case 'entertainment': return Icons.movie;
      default: return Icons.category;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);
    
    // SAFE DYNAMIC FILTERING LOGIC
    final currentMonthExpenses = expenseProvider.expenses.where((e) {
      try {
        return e.date.year == _selectedMonth.year && e.date.month == _selectedMonth.month;
      } catch (error) {
        return false; 
      }
    }).toList();
    
    // SAFE SORTING LOGIC
    currentMonthExpenses.sort((a, b) {
      try {
        // ignore: unnecessary_null_comparison
        return b.date.compareTo(a.date);
      } catch (error) {
        return 0;
      }
    });

    // Calculate total and breakdown dynamically for the selected month
    final totalSpent = currentMonthExpenses.fold(0.0, (sum, item) => sum + item.amount);

    final Map<String, double> breakdown = {};
    for (var exp in currentMonthExpenses) {
      breakdown[exp.category] = (breakdown[exp.category] ?? 0) + exp.amount;
    }
 
    return Scaffold(
      body: SafeArea(
        child: expenseProvider.isLoading
            ? const LoadingStateWidget(message: 'Loading your dashboard...')
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
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              ),
                              Text(
                                _getUserName(authProvider),
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            // ignore: deprecated_member_use
                            backgroundColor: primaryColor.withOpacity(0.1),
                            radius: 22,
                            child: IconButton(
                              icon: Icon(Icons.person, color: primaryColor, size: 20),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
 
                      // Total Spending Card with Functional Month Selector
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1F3D32), Color(0xFF5F806F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: const Color(0xFF1F3D32).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Total Spent',
                                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                // FUNCTIONAL MONTH SELECTOR
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => _changeMonth(-1),
                                      child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('MMM yyyy').format(_selectedMonth),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _changeMonth(1),
                                      child: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              currencyFormat.format(totalSpent),
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 32, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
 
                      // Styled Chart Section (Side-by-side with Legend)
                      const Text('Spending by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            // ignore: deprecated_member_use
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                        ),
                        child: breakdown.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Text('No expenses yet this month.', style: TextStyle(color: Colors.grey)),
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      height: 120,
                                      child: PieChart(
                                        PieChartData(
                                          sectionsSpace: 2,
                                          centerSpaceRadius: 35,
                                          sections: breakdown.entries.map((entry) {
                                            return PieChartSectionData(
                                              color: _getCategoryColor(entry.key),
                                              value: entry.value,
                                              title: '', 
                                              radius: 20,
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: breakdown.entries.take(4).map((entry) { 
                                        final percentage = totalSpent > 0 ? (entry.value / totalSpent) * 100 : 0;
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(radius: 5, backgroundColor: _getCategoryColor(entry.key)),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  entry.key, 
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '${percentage.toStringAsFixed(0)}%', 
                                                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 32),
 
                      // Recent Expenses Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {}, 
                            child: Text('See All', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Recent Expenses List OR Empty State
                      if (currentMonthExpenses.isEmpty)
                        EmptyStateWidget(
                          title: 'No expenses yet',
                          message: 'Start tracking your spending by adding your first expense.',
                          buttonText: 'Add Expense',
                          onAction: () {
                            Navigator.pushNamed(context, '/add_expense');
                          },
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentMonthExpenses.length > 5 ? 5 : currentMonthExpenses.length,
                          itemBuilder: (context, index) {
                            final expense = currentMonthExpenses[index];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                leading: CircleAvatar(
                                  // ignore: deprecated_member_use
                                  backgroundColor: _getCategoryColor(expense.category).withOpacity(0.15),
                                  child: Icon(_getCategoryIcon(expense.category), color: _getCategoryColor(expense.category), size: 20),
                                ),
                                title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                subtitle: Text(
                                  '${DateFormat('MMM dd').format(expense.date)} • ${expense.category}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                trailing: Text(
                                  currencyFormat.format(expense.amount),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            );
                          },
                        ),
                        
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}