import 'package:flutter/material.dart';
import 'package:mintworth/models/portfolio.dart';
import 'package:mintworth/services/portfolio_service.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _portfolioService = PortfolioService();
  Portfolio? _portfolio;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    final portfolio = await _portfolioService.getPortfolio(); // No user.id argument!
    setState(() {
      _portfolio = portfolio;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Virtual Portfolio', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPortfolio,
          ),
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildBody(theme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showBuyDialog,
        icon: const Icon(Icons.add),
        label: const Text('Buy Stock'),
        backgroundColor: theme.colorScheme.secondary,
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _loadPortfolio,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(theme),
            const SizedBox(height: 24),
            _buildChartCard(theme),
            const SizedBox(height: 24),
            _buildHoldingsSection(theme),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    final portfolio = _portfolio!;
    final isProfit = portfolio.totalProfitLoss >= 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withAlpha(180)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withAlpha(80), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Portfolio Value', style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 14)),
          const SizedBox(height: 8),
          Text('₹${portfolio.totalValue.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Virtual Cash', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('₹${portfolio.virtualCash.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total P&L', style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(isProfit ? Icons.trending_up : Icons.trending_down, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('₹${portfolio.totalProfitLoss.abs().toStringAsFixed(2)} (${portfolio.profitLossPercent.toStringAsFixed(2)}%)', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(ThemeData theme) {
    final portfolio = _portfolio!;
    if (portfolio.holdings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10)]),
        child: const Center(child: Text('No investments yet. Start by buying stocks!')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Portfolio Distribution', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: portfolio.holdings.asMap().entries.map((entry) {
                  final colors = [theme.colorScheme.primary, theme.colorScheme.secondary, theme.colorScheme.tertiary, Colors.purple, Colors.teal, Colors.orange];
                  return PieChartSectionData(
                    value: entry.value.currentValue,
                    title: entry.value.symbol,
                    color: colors[entry.key % colors.length],
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingsSection(ThemeData theme) {
    final portfolio = _portfolio!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Holdings', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (portfolio.holdings.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('No holdings yet')),
          )
        else
          ...portfolio.holdings.map((holding) => _buildHoldingCard(holding, theme)),
      ],
    );
  }

  Widget _buildHoldingCard(PortfolioHolding holding, ThemeData theme) {
    final isProfit = holding.profitLoss >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(holding.symbol, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(holding.name, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.sell, size: 20),
                color: theme.colorScheme.error,
                onPressed: () => _showSellDialog(holding),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quantity: ${holding.quantity}', style: theme.textTheme.bodySmall),
                  Text('Avg. Price: ₹${holding.buyPrice.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Current: ₹${holding.currentPrice.toStringAsFixed(2)}', style: theme.textTheme.bodySmall),
                  Row(
                    children: [
                      Icon(isProfit ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: isProfit ? Colors.green : Colors.red),
                      Text('₹${holding.profitLoss.abs().toStringAsFixed(2)} (${holding.profitLossPercent.toStringAsFixed(2)}%)', style: TextStyle(color: isProfit ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBuyDialog() {
    final stocks = _portfolioService.getAvailableStocks();
    String? selectedSymbol;
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Buy Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Select Stock', border: OutlineInputBorder()),
                items: stocks.map((s) => DropdownMenuItem(value: s['symbol'] as String, child: Text('${s['symbol']} - ₹${s['price']}'))).toList(),
                onChanged: (value) => setDialogState(() => selectedSymbol = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onChanged: (value) => setDialogState(() => quantity = int.tryParse(value) ?? 1),
              ),
              if (selectedSymbol != null) ...[
                const SizedBox(height: 16),
                Text('Total: ₹${(stocks.firstWhere((s) => s['symbol'] == selectedSymbol)['price'] as double) * quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (selectedSymbol != null) {
                  try {
                    final stock = stocks.firstWhere((s) => s['symbol'] == selectedSymbol);
                    await _portfolioService.buyStock(selectedSymbol!, stock['name'] as String, quantity, stock['price'] as double);
                    await _loadPortfolio();
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock purchased successfully!')));
                    }
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellDialog(PortfolioHolding holding) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Sell ${holding.symbol}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Available: ${holding.quantity} shares'),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onChanged: (value) => setDialogState(() => quantity = int.tryParse(value) ?? 1),
              ),
              const SizedBox(height: 16),
              Text('Total: ₹${holding.currentPrice * quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _portfolioService.sellStock(holding.symbol, quantity); // Only pass symbol and quantity!
                  await _loadPortfolio();
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock sold successfully!')));
                  }
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Sell'),
            ),
          ],
        ),
      ),
    );
  }
}
