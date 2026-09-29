import 'dart:async';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/database_service.dart';

class ExpenseProvider with ChangeNotifier {
  DatabaseService? _dbService;
  StreamSubscription<List<Expense>>? _expenseSubscription;

  List<Expense> _expenses = [];
  bool _isLoading = true;
  String? _error;

  // Filters
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Initialize service when user logs in
  void updateUser(String? userId) {
    if (userId == null) {
      _expenseSubscription?.cancel();
      _expenses = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _dbService = DatabaseService(userId: userId);
    _expenseSubscription?.cancel();
    _expenseSubscription = _dbService!.getExpenses().listen(
      (data) {
        _expenses = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _error = err.toString();
        notifyListeners();
      },
    );
  }

  // Filtered expenses list
  List<Expense> get filteredExpenses {
    return _expenses.where((expense) {
      final matchesCategory = _selectedCategory == 'All' ||
          expense.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          expense.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Calculate current month's total spending
  double get currentMonthTotal {
    final now = DateTime.now();
    return _expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Category breakdown for charts and dashboard
  Map<String, double> get categoryBreakdown {
    final Map<String, double> breakdown = {};
    for (var expense in _expenses) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0.0) + expense.amount;
    }
    return breakdown;
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // CRUD forwarding
  Future<void> addExpense(Expense expense) async {
    if (_dbService != null) await _dbService!.addExpense(expense);
  }

  Future<void> updateExpense(Expense expense) async {
    if (_dbService != null) await _dbService!.updateExpense(expense);
  }

  Future<void> deleteExpense(String expenseId) async {
    if (_dbService != null) await _dbService!.deleteExpense(expenseId);
  }

  @override
  void dispose() {
    _expenseSubscription?.cancel();
    super.dispose();
  }
}