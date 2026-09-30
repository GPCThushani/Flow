import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flow/models/expense.dart';
import 'package:flow/providers/expense_provider.dart';

class CategorySummaryScreen extends StatelessWidget {
  final String category;

  const CategorySummaryScreen({super.key, required this.category});

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

  // Generates bar chart data for the last 7 days for this category
  List<BarChartGroupData> _generateChartData(List<Expense> categoryExpenses, Color barColor) {
    final now = DateTime.now();
    List<BarChartGroupData> barGroups = [];
    
    for (int i = 6; i >= 0; i--) {
      final targetDate = now.subtract(Duration(days: i));
      final dailyTotal = categoryExpenses
          .where((e) => e.date.year == targetDate.year && e.date.month == targetDate.month && e.date.day == targetDate.day)
          .fold(0.0, (sum, item) => sum + item.amount);

      barGroups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: dailyTotal,
              // ignore: deprecated_member_use
              color: barColor.withOpacity(dailyTotal > 0 ? 1.0 : 0.3),
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);
    final categoryColor = _getCategoryColor(category);

    // Filter expenses for this specific category in the current month
    final now = DateTime.now();
    final categoryExpenses = expenseProvider.expenses.where((e) => 
        e.category == category && e.date.year == now.year && e.date.month == now.month
    ).toList();

    // Calculate totals and percentages
    final categoryTotal = categoryExpenses.fold(0.0, (sum, item) => sum + item.amount);
    final overallTotal = expenseProvider.currentMonthTotal;
    final percentage = overallTotal > 0 ? (categoryTotal / overallTotal) * 100 : 0.0;

    // Sort for Top Items (Highest amount first)
    final topItems = List<Expense>.from(categoryExpenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final displayItems = topItems.take(5).toList(); // Show top 5

    return Scaffold(
      appBar: AppBar(
        title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Spent Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    // ignore: deprecated_member_use
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Spent', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(currencyFormat.format(categoryTotal), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('${percentage.toStringAsFixed(0)}% of total expenses', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bar Chart Card
              Container(
                height: 200,
                padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: categoryExpenses.isEmpty ? 1000 : null, // Default scale if empty
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final date = now.subtract(Duration(days: 6 - value.toInt()));
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(DateFormat('E').format(date).substring(0, 1), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: _generateChartData(categoryExpenses, categoryColor),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Top Items List
              const Text('Top Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              if (displayItems.isEmpty)
                const Center(child: Text('No items to display.', style: TextStyle(color: Colors.grey)))
              else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: displayItems.map((item) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          // ignore: deprecated_member_use
                          backgroundColor: categoryColor.withOpacity(0.15),
                          child: Icon(_getCategoryIcon(item.category), color: categoryColor, size: 20),
                        ),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: Text(
                          currencyFormat.format(item.amount),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}