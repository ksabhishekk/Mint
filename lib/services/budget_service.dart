import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mintworth/models/budget.dart';

class BudgetService {
  Future<Budget> getBudget() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    final budgetMap = data?['budget'];
    if (budgetMap != null) {
      return Budget.fromJson(Map<String, dynamic>.from(budgetMap));
    }
    // If missing, return a new budget with sensible defaults
    final now = DateTime.now();
    final newBudget = Budget(
      id: 'budget1',
      userId: uid,
      monthlyIncome: 35000.0,
      savingsGoal: 10000.0,
      transactions: [],
      createdAt: now,
      updatedAt: now,
    );
    await saveBudget(newBudget); // Initialize in Firestore
    return newBudget;
  }

  Future<void> saveBudget(Budget budget) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'budget': budget.toJson()});
  }

  Future<Budget> addTransaction(BudgetTransaction transaction) async {
    final budget = await getBudget();
    final updated = budget.copyWith(
      transactions: [...budget.transactions, transaction],
      updatedAt: DateTime.now(),
    );
    await saveBudget(updated);
    return updated;
  }

  Future<Budget> deleteTransaction(String transactionId) async {
    final budget = await getBudget();
    final updated = budget.copyWith(
      transactions: budget.transactions.where((t) => t.id != transactionId).toList(),
      updatedAt: DateTime.now(),
    );
    await saveBudget(updated);
    return updated;
  }

  Future<Budget> updateBudgetGoals(double income, double goal) async {
    final budget = await getBudget();
    final updated = budget.copyWith(
      monthlyIncome: income,
      savingsGoal: goal,
      updatedAt: DateTime.now(),
    );
    await saveBudget(updated);
    return updated;
  }

  Map<String, double> getCategoryTotals(Budget budget) {
    final Map<String, double> totals = {};
    for (var transaction in budget.transactions) {
      if (transaction.type == 'expense') {
        totals[transaction.category] = (totals[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return totals;
  }

  List<String> getExpenseCategories() => [
    'Food',
    'Transport',
    'Entertainment',
    'Shopping',
    'Bills',
    'Healthcare',
    'Education',
    'Other',
  ];
}
