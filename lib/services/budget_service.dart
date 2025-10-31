import 'package:mintworth/models/budget.dart';
import 'package:mintworth/services/local_storage_service.dart';

class BudgetService {
  static const String _key = 'budget';

  Future<Budget> getBudget(String userId) async {
    final json = LocalStorageService.getJson(_key);
    if (json != null) return Budget.fromJson(json);

    final now = DateTime.now();
    final newBudget = Budget(
      id: 'budget1',
      userId: userId,
      monthlyIncome: 35000.0,
      savingsGoal: 10000.0,
      transactions: [
        BudgetTransaction(
          id: 'txn1',
          category: 'Salary',
          amount: 35000.0,
          type: 'income',
          description: 'Monthly salary',
          date: now.subtract(const Duration(days: 25)),
        ),
        BudgetTransaction(
          id: 'txn2',
          category: 'Food',
          amount: 3500.0,
          type: 'expense',
          description: 'Groceries',
          date: now.subtract(const Duration(days: 20)),
        ),
        BudgetTransaction(
          id: 'txn3',
          category: 'Transport',
          amount: 2000.0,
          type: 'expense',
          description: 'Uber/Metro',
          date: now.subtract(const Duration(days: 18)),
        ),
        BudgetTransaction(
          id: 'txn4',
          category: 'Entertainment',
          amount: 1500.0,
          type: 'expense',
          description: 'Movies and dining',
          date: now.subtract(const Duration(days: 15)),
        ),
        BudgetTransaction(
          id: 'txn5',
          category: 'Bills',
          amount: 4000.0,
          type: 'expense',
          description: 'Rent contribution',
          date: now.subtract(const Duration(days: 10)),
        ),
        BudgetTransaction(
          id: 'txn6',
          category: 'Shopping',
          amount: 2500.0,
          type: 'expense',
          description: 'Clothing',
          date: now.subtract(const Duration(days: 5)),
        ),
      ],
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
    await saveBudget(newBudget);
    return newBudget;
  }

  Future<void> saveBudget(Budget budget) async {
    await LocalStorageService.saveJson(_key, budget.toJson());
  }

  Future<Budget> addTransaction(Budget budget, BudgetTransaction transaction) async {
    final updated = budget.copyWith(
      transactions: [...budget.transactions, transaction],
      updatedAt: DateTime.now(),
    );
    await saveBudget(updated);
    return updated;
  }

  Future<Budget> deleteTransaction(Budget budget, String transactionId) async {
    final updated = budget.copyWith(
      transactions: budget.transactions.where((t) => t.id != transactionId).toList(),
      updatedAt: DateTime.now(),
    );
    await saveBudget(updated);
    return updated;
  }

  Future<Budget> updateBudgetGoals(Budget budget, double income, double goal) async {
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
