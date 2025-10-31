class Budget {
  final String id;
  final String userId;
  final double monthlyIncome;
  final double savingsGoal;
  final List<BudgetTransaction> transactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Budget({
    required this.id,
    required this.userId,
    required this.monthlyIncome,
    required this.savingsGoal,
    this.transactions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalExpenses => transactions
    .where((t) => t.type == 'expense')
    .fold(0.0, (sum, t) => sum + t.amount);

  double get totalIncome => transactions
    .where((t) => t.type == 'income')
    .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpenses;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'monthlyIncome': monthlyIncome,
    'savingsGoal': savingsGoal,
    'transactions': transactions.map((t) => t.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    id: json['id'] as String,
    userId: json['userId'] as String,
    monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
    savingsGoal: (json['savingsGoal'] as num).toDouble(),
    transactions: (json['transactions'] as List<dynamic>?)
      ?.map((t) => BudgetTransaction.fromJson(t as Map<String, dynamic>))
      .toList() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Budget copyWith({
    String? id,
    String? userId,
    double? monthlyIncome,
    double? savingsGoal,
    List<BudgetTransaction>? transactions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Budget(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    monthlyIncome: monthlyIncome ?? this.monthlyIncome,
    savingsGoal: savingsGoal ?? this.savingsGoal,
    transactions: transactions ?? this.transactions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class BudgetTransaction {
  final String id;
  final String category;
  final double amount;
  final String type;
  final String description;
  final DateTime date;

  BudgetTransaction({
    required this.id,
    required this.category,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'amount': amount,
    'type': type,
    'description': description,
    'date': date.toIso8601String(),
  };

  factory BudgetTransaction.fromJson(Map<String, dynamic> json) => BudgetTransaction(
    id: json['id'] as String,
    category: json['category'] as String,
    amount: (json['amount'] as num).toDouble(),
    type: json['type'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
  );
}
