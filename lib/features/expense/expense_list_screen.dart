import 'package:flow/features/expense/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flow/models/expense.dart';
import 'package:flow/providers/expense_provider.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedDateRange = 'All time';

  final List<String> _categories = [
    'All', 'Food', 'Transport', 'Shopping', 'Bills', 'Health', 'Entertainment', 'Other'
  ];

  final List<String> _dateRanges = [
    'All time', 'This month', 'Last month',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _confirmDelete(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<ExpenseProvider>(context, listen: false);
              await provider.deleteExpense(expense.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

 
  void _showExpenseDetailPopup(BuildContext context, Expense expense) {
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);
    final categoryColor = _getCategoryColor(expense.category);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), 
                  CircleAvatar(
                    radius: 36,
                    // ignore: deprecated_member_use
                    backgroundColor: categoryColor.withOpacity(0.15),
                    child: Icon(_getCategoryIcon(expense.category), size: 36, color: categoryColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.pop(ctx); 
                      _confirmDelete(context, expense); 
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(expense.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(expense.category, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 16),
              Text(currencyFormat.format(expense.amount), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(DateFormat('MMM dd, yyyy • hh:mm a').format(expense.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              
              if (expense.note != null && expense.note!.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    // ignore: deprecated_member_use
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(expense.note!, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddExpenseScreen(expenseToEdit: expense)),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(width: 16), 
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _confirmDelete(context, expense);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5252), 
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openFilterBottomSheet(BuildContext context) {
    String tempCategory = _selectedCategory;
    String tempDateRange = _selectedDateRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final primaryColor = Theme.of(context).primaryColor;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSelected = tempCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          showCheckmark: isSelected,
                          checkmarkColor: Colors.black87,
                          selectedColor: Colors.grey.shade300,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black87, 
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade400),
                          ),
                          onSelected: (selected) {
                            if (selected) setModalState(() => tempCategory = cat);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _dateRanges.map((range) {
                        final isSelected = tempDateRange == range;
                        return ChoiceChip(
                          label: Text(range),
                          selected: isSelected,
                          showCheckmark: isSelected,
                          checkmarkColor: Colors.black87,
                          selectedColor: Colors.grey.shade300,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black87, 
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade400),
                          ),
                          onSelected: (selected) {
                            if (selected) setModalState(() => tempDateRange = range);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCategory = tempCategory;
                            _selectedDateRange = tempDateRange;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Expense> _getFilteredExpenses(List<Expense> allExpenses) {
    final now = DateTime.now();

    return allExpenses.where((expense) {
      final matchesSearch = expense.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          expense.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == 'All' ||
          expense.category.toLowerCase() == _selectedCategory.toLowerCase();

      bool matchesDate = true;
      if (_selectedDateRange == 'This month') {
        matchesDate = expense.date.year == now.year && expense.date.month == now.month;
      } else if (_selectedDateRange == 'Last month') {
        final lastMonth = now.month == 1 ? 12 : now.month - 1;
        final year = now.month == 1 ? now.year - 1 : now.year;
        matchesDate = expense.date.year == year && expense.date.month == lastMonth;
      }

      return matchesSearch && matchesCategory && matchesDate;
    }).toList();
  }

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};
    for (var exp in expenses) {
      final dateKey = DateFormat('MMM dd, yyyy').format(exp.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(exp);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ', decimalDigits: 2);

    final filtered = _getFilteredExpenses(expenseProvider.expenses);
    final grouped = _groupExpensesByDate(filtered);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 8,
        // ignore: deprecated_member_use
        shadowColor: const Color(0xFF1F3D32).withOpacity(0.5),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1F3D32), // Deep Green
                Color(0xFF5F806F), // Muted Green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Outlined Filter buttons matching the design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search expenses...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        label: Text(_selectedCategory, style: const TextStyle(color: Colors.black87)),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        onPressed: () => _openFilterBottomSheet(context),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black87),
                        label: Text(_selectedDateRange, style: const TextStyle(color: Colors.black87)),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        onPressed: () => _openFilterBottomSheet(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            // Expense List
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No matching expenses found.', style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      itemCount: grouped.keys.length,
                      itemBuilder: (context, index) {
                        final dateHeader = grouped.keys.elementAt(index);
                        final items = grouped[dateHeader]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                              child: Text(
                                dateHeader,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                              ),
                            ),
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                // ignore: deprecated_member_use
                                side: BorderSide(color: Colors.grey.withOpacity(0.15)),
                              ),
                              child: Column(
                                children: items.map((expense) {
                                  return ListTile(
                                    onTap: () => _showExpenseDetailPopup(context, expense), // Triggers the popup dialog
                                    leading: CircleAvatar(
                                      // ignore: deprecated_member_use
                                      backgroundColor: _getCategoryColor(expense.category).withOpacity(0.15),
                                      child: Icon(
                                        _getCategoryIcon(expense.category),
                                        color: _getCategoryColor(expense.category),
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    subtitle: Text(expense.category),
                                    trailing: Text(
                                      currencyFormat.format(expense.amount),
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}