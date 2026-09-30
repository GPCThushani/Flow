import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flow/providers/expense_provider.dart';
import 'package:flow/features/summary/category_summary_screen.dart'; // Ensure this is imported!

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
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
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);
    final currentMonthStr = DateFormat('MMMM yyyy').format(DateTime.now());

    final totalSpent = expenseProvider.currentMonthTotal;
    final breakdown = expenseProvider.categoryBreakdown;
    
    String topCategory = 'None';
    double topCategoryAmount = 0.0;
    if (breakdown.isNotEmpty) {
      final topEntry = breakdown.entries.reduce((a, b) => a.value > b.value ? a : b);
      topCategory = topEntry.key;
      topCategoryAmount = topEntry.value;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monthly Summary', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: false, // Aligned Left
        elevation: 16, // Increased shadow height/depth
        // ignore: deprecated_member_use
        shadowColor: const Color(0xFF1F3D32).withOpacity(0.7),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F3D32), Color(0xFF5F806F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(currentMonthStr, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    // ignore: deprecated_member_use
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Total Spent', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(currencyFormat.format(totalSpent), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text('Category Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              if (breakdown.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('No expenses yet this month.', style: TextStyle(color: Colors.grey)),
                  ),
                )
              else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 150,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: breakdown.entries.map((entry) {
                              return PieChartSectionData(
                                color: _getCategoryColor(entry.key),
                                value: entry.value,
                                title: '',
                                radius: 25,
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
                        children: breakdown.entries.map((entry) {
                          final percentage = (entry.value / totalSpent) * 100;
                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategorySummaryScreen(category: entry.key),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              child: Row(
                                children: [
                                  CircleAvatar(radius: 4, backgroundColor: _getCategoryColor(entry.key)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(entry.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                  Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  Text(
                                    NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 0).format(entry.value),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Text('Top Spending Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // Made the top spending category card clickable too!
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (topCategory != 'None') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategorySummaryScreen(category: topCategory),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          // ignore: deprecated_member_use
                          backgroundColor: _getCategoryColor(topCategory).withOpacity(0.15),
                          radius: 24,
                          child: Icon(_getCategoryIcon(topCategory), color: _getCategoryColor(topCategory)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(topCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(
                                '${((topCategoryAmount / totalSpent) * 100).toStringAsFixed(0)}% of total expenses',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currencyFormat.format(topCategoryAmount),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}