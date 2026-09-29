import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  DatabaseService({required this.userId});

  // Get a reference to the user's specific expenses collection
  CollectionReference get _expensesCollection => 
      _db.collection('users').doc(userId).collection('expenses');

  // CREATE: Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expensesCollection.add(expense.toMap());
  }

  // READ: Get a stream of expenses ordered by date
  Stream<List<Expense>> getExpenses() {
    return _expensesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Expense.fromFirestore(doc))
            .toList());
  }

  // UPDATE: Edit an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _expensesCollection.doc(expense.id).update(expense.toMap());
  }

  // DELETE: Remove an expense
  Future<void> deleteExpense(String expenseId) async {
    await _expensesCollection.doc(expenseId).delete();
  }
}