import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flow/models/expense.dart';
import 'package:flow/providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expenseToEdit; 

  const AddExpenseScreen({super.key, this.expenseToEdit});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  
  late String _selectedCategory;
  late DateTime _selectedDate;
  bool _isLoading = false;

  final List<String> _categories = ['Food', 'Transport', 'Shopping', 'Bills', 'Health', 'Entertainment', 'Other'];

  @override
  void initState() {
    super.initState();
    // Pre-fill the form if we are editing!
    _titleController = TextEditingController(text: widget.expenseToEdit?.title ?? '');
    _amountController = TextEditingController(text: widget.expenseToEdit?.amount.toString() ?? '');
    _noteController = TextEditingController(text: widget.expenseToEdit?.note ?? '');
    _selectedCategory = widget.expenseToEdit?.category ?? 'Food';
    _selectedDate = widget.expenseToEdit?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    
    final newExpense = Expense(
      id: widget.expenseToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), 
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    try {
      if (widget.expenseToEdit != null) {
        await expenseProvider.updateExpense(newExpense); 
      } else {
        await expenseProvider.addExpense(newExpense);
      }
      if (mounted) Navigator.pop(context); 
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent));
      }
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isEditing = widget.expenseToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Expense' : 'Add Expense', 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLabel('Title *'),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'e.g. Groceries'),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                ),
                _buildLabel('Amount *'),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(hintText: '0.00', prefixText: 'Rs. '),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter an amount';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    return null;
                  },
                ),
                _buildLabel('Category *'),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  icon: const Icon(Icons.chevron_right),
                  items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (val) { if (val != null) setState(() => _selectedCategory = val); },
                ),
                _buildLabel('Date *'),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: IgnorePointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: DateFormat('MMM dd, yyyy').format(_selectedDate),
                        prefixIcon: const Icon(Icons.calendar_today, size: 20),
                        suffixIcon: const Icon(Icons.calendar_month, size: 20),
                      ),
                    ),
                  ),
                ),
                _buildLabel('Note (Optional)'),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Add a note...'),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveExpense,
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                          child: Text(isEditing ? 'Save Changes' : 'Save Expense', style: const TextStyle(fontSize: 16)),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}