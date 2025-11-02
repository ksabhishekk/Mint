import 'package:cloud_firestore/cloud_firestore.dart';

class Portfolio {
  final String id;
  final String userId;
  final double virtualCash;
  final double totalInvested;
  final List<PortfolioHolding> holdings;
  final DateTime createdAt;
  final DateTime updatedAt;

  Portfolio({
    required this.id,
    required this.userId,
    required this.virtualCash,
    this.totalInvested = 0,
    this.holdings = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalValue => virtualCash + holdings.fold(0.0, (sum, h) => sum + h.currentValue);
  double get totalProfitLoss => totalValue - 100000.0;
  double get profitLossPercent => ((totalValue - 100000.0) / 100000.0) * 100;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'virtualCash': virtualCash,
    'totalInvested': totalInvested,
    'holdings': holdings.map((h) => h.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
    id: (json['id'] ?? '') as String,
    userId: (json['userId'] ?? '') as String,
    virtualCash: (json['virtualCash'] is num ? (json['virtualCash'] as num).toDouble() : 0),
    totalInvested: (json['totalInvested'] is num ? (json['totalInvested'] as num).toDouble() : 0),
    holdings: (json['holdings'] as List<dynamic>? ?? [])
      .map((h) => PortfolioHolding.fromJson(Map<String, dynamic>.from(h)))
      .toList(),
    createdAt: _parseDate(json['createdAt']),
    updatedAt: _parseDate(json['updatedAt']),
  );

  static DateTime _parseDate(dynamic val) {
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
    return DateTime.now();
  }

  Portfolio copyWith({
    String? id,
    String? userId,
    double? virtualCash,
    double? totalInvested,
    List<PortfolioHolding>? holdings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Portfolio(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    virtualCash: virtualCash ?? this.virtualCash,
    totalInvested: totalInvested ?? this.totalInvested,
    holdings: holdings ?? this.holdings,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class PortfolioHolding {
  final String symbol;
  final String name;
  final String type;
  final int quantity;
  final double buyPrice;
  final double currentPrice;
  final DateTime purchaseDate;

  PortfolioHolding({
    required this.symbol,
    required this.name,
    required this.type,
    required this.quantity,
    required this.buyPrice,
    required this.currentPrice,
    required this.purchaseDate,
  });

  double get currentValue => quantity * currentPrice;
  double get investedValue => quantity * buyPrice;
  double get profitLoss => currentValue - investedValue;
  double get profitLossPercent => buyPrice == 0 ? 0 : ((currentPrice - buyPrice) / buyPrice) * 100;

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'type': type,
    'quantity': quantity,
    'buyPrice': buyPrice,
    'currentPrice': currentPrice,
    'purchaseDate': purchaseDate.toIso8601String(),
  };

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) => PortfolioHolding(
    symbol: (json['symbol'] ?? '') as String,
    name: (json['name'] ?? '') as String,
    type: (json['type'] ?? '') as String,
    quantity: (json['quantity'] ?? 0) as int,
    buyPrice: (json['buyPrice'] is num ? (json['buyPrice'] as num).toDouble() : 0),
    currentPrice: (json['currentPrice'] is num ? (json['currentPrice'] as num).toDouble() : 0),
    purchaseDate: Portfolio._parseDate(json['purchaseDate']),
  );

  PortfolioHolding copyWith({
    String? symbol,
    String? name,
    String? type,
    int? quantity,
    double? buyPrice,
    double? currentPrice,
    DateTime? purchaseDate,
  }) => PortfolioHolding(
    symbol: symbol ?? this.symbol,
    name: name ?? this.name,
    type: type ?? this.type,
    quantity: quantity ?? this.quantity,
    buyPrice: buyPrice ?? this.buyPrice,
    currentPrice: currentPrice ?? this.currentPrice,
    purchaseDate: purchaseDate ?? this.purchaseDate,
  );
}
