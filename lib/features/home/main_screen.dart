import 'package:flutter/material.dart';
import 'package:flow/features/home/home_screen.dart';
import 'package:flow/features/expense/expense_list_screen.dart';
import 'package:flow/features/summary/summary_screen.dart';
import 'package:flow/features/settings/more_screen.dart';
import 'package:flow/features/expense/add_expense_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExpenseListScreen(),
    const SummaryScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
        },
        backgroundColor: primaryColor,
        elevation: 6,
        // ignore: deprecated_member_use
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, 
        surfaceTintColor: Colors.transparent, 
        elevation: 20, 
        shadowColor: Colors.black87, 
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 70,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(child: _buildNavItem(Icons.home, 'Home', 0, primaryColor)),
            Expanded(child: _buildNavItem(Icons.account_balance_wallet, 'Expenses', 1, primaryColor)),
            const Expanded(child: SizedBox.shrink()), // Invisible gap for FAB
            Expanded(child: _buildNavItem(Icons.pie_chart, 'Summary', 2, primaryColor)),
            Expanded(child: _buildNavItem(Icons.more_horiz, 'More', 3, primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Color primaryColor) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? primaryColor : Colors.grey.shade400, size: 26),
          const SizedBox(height: 4),
          Text(
            label, 
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.grey.shade500, 
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
            )
          ),
        ],
      ),
    );
  }
}