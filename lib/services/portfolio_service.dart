import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mintworth/models/portfolio.dart';

class PortfolioService {
  final _random = Random();

  Future<Portfolio> getPortfolio() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    final portfolioMap = data?['portfolio'];
    if (portfolioMap != null) {
      final portfolio = Portfolio.fromJson(Map<String, dynamic>.from(portfolioMap));
      return _updatePrices(portfolio);
    }
    // Default starting portfolio
    final now = DateTime.now();
    final newPortfolio = Portfolio(
      id: 'portfolio1',
      userId: uid,
      virtualCash: 55000.0,
      totalInvested: 45000.0,
      holdings: [
        PortfolioHolding(
          symbol: 'RELIANCE',
          name: 'Reliance Industries',
          type: 'Stock',
          quantity: 10,
          buyPrice: 2450.0,
          currentPrice: 2520.0,
          purchaseDate: now.subtract(const Duration(days: 15)),
        ),
        PortfolioHolding(
          symbol: 'TCS',
          name: 'Tata Consultancy Services',
          type: 'Stock',
          quantity: 5,
          buyPrice: 3650.0,
          currentPrice: 3720.0,
          purchaseDate: now.subtract(const Duration(days: 20)),
        ),
        PortfolioHolding(
          symbol: 'HDFCBANK',
          name: 'HDFC Bank',
          type: 'Stock',
          quantity: 8,
          buyPrice: 1580.0,
          currentPrice: 1610.0,
          purchaseDate: now.subtract(const Duration(days: 10)),
        ),
      ],
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
    await savePortfolio(newPortfolio);
    return newPortfolio;
  }

  Portfolio _updatePrices(Portfolio portfolio) {
    final updatedHoldings = portfolio.holdings.map((holding) {
      final change = (_random.nextDouble() - 0.5) * 0.02;
      final newPrice = holding.currentPrice * (1 + change);
      return holding.copyWith(currentPrice: newPrice);
    }).toList();

    return portfolio.copyWith(
      holdings: updatedHoldings,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> savePortfolio(Portfolio portfolio) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'portfolio': portfolio.toJson()});
  }

  Future<Portfolio> buyStock(String symbol, String name, int quantity, double price) async {
    final portfolio = await getPortfolio();
    final cost = quantity * price;
    if (portfolio.virtualCash < cost) {
      throw Exception('Insufficient funds');
    }

    final existingIndex = portfolio.holdings.indexWhere((h) => h.symbol == symbol);
    List<PortfolioHolding> updatedHoldings;

    if (existingIndex >= 0) {
      final existing = portfolio.holdings[existingIndex];
      final totalQuantity = existing.quantity + quantity;
      final avgPrice = ((existing.buyPrice * existing.quantity) + (price * quantity)) / totalQuantity;
      updatedHoldings = List.from(portfolio.holdings);
      updatedHoldings[existingIndex] = existing.copyWith(
        quantity: totalQuantity,
        buyPrice: avgPrice,
        currentPrice: price,
      );
    } else {
      updatedHoldings = [
        ...portfolio.holdings,
        PortfolioHolding(
          symbol: symbol,
          name: name,
          type: 'Stock',
          quantity: quantity,
          buyPrice: price,
          currentPrice: price,
          purchaseDate: DateTime.now(),
        ),
      ];
    }

    final updated = portfolio.copyWith(
      virtualCash: portfolio.virtualCash - cost,
      totalInvested: portfolio.totalInvested + cost,
      holdings: updatedHoldings,
      updatedAt: DateTime.now(),
    );

    await savePortfolio(updated);
    return updated;
  }

  Future<Portfolio> sellStock(String symbol, int quantity) async {
    final portfolio = await getPortfolio();
    final holdingIndex = portfolio.holdings.indexWhere((h) => h.symbol == symbol);
    if (holdingIndex < 0) throw Exception('Stock not found');

    final holding = portfolio.holdings[holdingIndex];
    if (holding.quantity < quantity) throw Exception('Insufficient quantity');

    final proceeds = quantity * holding.currentPrice;
    List<PortfolioHolding> updatedHoldings = List.from(portfolio.holdings);

    if (holding.quantity == quantity) {
      updatedHoldings.removeAt(holdingIndex);
    } else {
      updatedHoldings[holdingIndex] = holding.copyWith(quantity: holding.quantity - quantity);
    }

    final updated = portfolio.copyWith(
      virtualCash: portfolio.virtualCash + proceeds,
      holdings: updatedHoldings,
      updatedAt: DateTime.now(),
    );

    await savePortfolio(updated);
    return updated;
  }

  List<Map<String, dynamic>> getAvailableStocks() => [
        {'symbol': 'RELIANCE', 'name': 'Reliance Industries', 'price': 2520.0},
        {'symbol': 'TCS', 'name': 'Tata Consultancy Services', 'price': 3720.0},
        {'symbol': 'HDFCBANK', 'name': 'HDFC Bank', 'price': 1610.0},
        {'symbol': 'INFY', 'name': 'Infosys', 'price': 1450.0},
        {'symbol': 'WIPRO', 'name': 'Wipro', 'price': 425.0},
        {'symbol': 'ICICIBANK', 'name': 'ICICI Bank', 'price': 985.0},
        {'symbol': 'SBIN', 'name': 'State Bank of India', 'price': 625.0},
        {'symbol': 'BHARTIARTL', 'name': 'Bharti Airtel', 'price': 1275.0},
      ];
}
