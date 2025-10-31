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
    id: json['id'] as String,
    userId: json['userId'] as String,
    virtualCash: (json['virtualCash'] as num).toDouble(),
    totalInvested: (json['totalInvested'] as num?)?.toDouble() ?? 0,
    holdings: (json['holdings'] as List<dynamic>?)
      ?.map((h) => PortfolioHolding.fromJson(h as Map<String, dynamic>))
      .toList() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

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
  double get profitLossPercent => ((currentPrice - buyPrice) / buyPrice) * 100;

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
    symbol: json['symbol'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    quantity: json['quantity'] as int,
    buyPrice: (json['buyPrice'] as num).toDouble(),
    currentPrice: (json['currentPrice'] as num).toDouble(),
    purchaseDate: DateTime.parse(json['purchaseDate'] as String),
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
