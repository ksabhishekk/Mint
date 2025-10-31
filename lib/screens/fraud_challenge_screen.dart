import 'package:flutter/material.dart';
import 'package:mintworth/models/fraud_challenge.dart';
import 'package:mintworth/services/fraud_service.dart';
import 'package:mintworth/services/user_service.dart';

class FraudChallengeScreen extends StatefulWidget {
  const FraudChallengeScreen({super.key});

  @override
  State<FraudChallengeScreen> createState() => _FraudChallengeScreenState();
}

class _FraudChallengeScreenState extends State<FraudChallengeScreen> {
  final _fraudService = FraudService();
  final _userService = UserService();
  List<FraudChallenge> _challenges = [];
  bool _isLoading = true;
  FraudChallenge? _activeChallenge;
  int? _selectedOption;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    final challenges = await _fraudService.getAllChallenges();
    setState(() {
      _challenges = challenges;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Fraud Alert', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          if (_activeChallenge != null)
            IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() {
              _activeChallenge = null;
              _selectedOption = null;
              _showResult = false;
            })),
        ],
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : (_activeChallenge == null ? _buildChallengesList(theme) : _buildChallengeView(theme)),
    );
  }

  Widget _buildChallengesList(ThemeData theme) {
    final completedCount = _challenges.where((c) => c.isCompleted).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade600, Colors.red.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.shield, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stay Safe Online', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('$completedCount/${_challenges.length} Completed', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Fraud Scenarios', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._challenges.map((challenge) => _buildChallengeCard(challenge, theme)),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(FraudChallenge challenge, ThemeData theme) {
    final typeColors = {'Phishing': Colors.red, 'UPI Fraud': Colors.orange, 'Investment Scam': Colors.purple, 'Lottery Scam': Colors.pink, 'Remote Access Scam': Colors.deepOrange, 'Job Scam': Colors.indigo};

    return GestureDetector(
      onTap: () => setState(() => _activeChallenge = challenge),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: challenge.isCompleted ? Border.all(color: Colors.green, width: 2) : null,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (typeColors[challenge.type] ?? Colors.red).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(challenge.isCompleted ? Icons.check_circle : Icons.warning, color: typeColors[challenge.type] ?? Colors.red, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(challenge.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(challenge.type, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.stars, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${challenge.pointsReward} pts', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeView(ThemeData theme) {
    if (_showResult) return _buildResult(theme);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.warning, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_activeChallenge!.type, style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
                const SizedBox(height: 16),
                Text(_activeChallenge!.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Scenario', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
            child: Text(_activeChallenge!.scenario, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
          ),
          const SizedBox(height: 24),
          Text('What should you do?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...List.generate(_activeChallenge!.options.length, (index) {
            return GestureDetector(
              onTap: () => setState(() => _selectedOption = index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedOption == index ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.cardColor,
                  border: Border.all(color: _selectedOption == index ? theme.colorScheme.primary : Colors.grey.withValues(alpha: 0.3), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _selectedOption == index ? theme.colorScheme.primary : Colors.grey, width: 2), color: _selectedOption == index ? theme.colorScheme.primary : Colors.transparent),
                      child: _selectedOption == index ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_activeChallenge!.options[index], style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption == null ? null : () => setState(() => _showResult = true),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Submit Answer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(ThemeData theme) {
    final isCorrect = _selectedOption == _activeChallenge!.correctOptionIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(isCorrect ? Icons.check_circle : Icons.cancel, size: 80, color: isCorrect ? Colors.green : Colors.red),
          ),
          const SizedBox(height: 24),
          Text(isCorrect ? 'Well Done!' : 'Not Quite Right', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Correct Action:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                Text(_activeChallenge!.correctAction, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text('Red Flags to Watch:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.red.shade900)),
                  ],
                ),
                const SizedBox(height: 12),
                ..._activeChallenge!.redFlags.map((flag) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(color: Colors.red.shade700, fontSize: 16, fontWeight: FontWeight.bold)),
                      Expanded(child: Text(flag, style: theme.textTheme.bodySmall)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          if (isCorrect) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars, color: Colors.amber, size: 32),
                  const SizedBox(width: 12),
                  Text('+${_activeChallenge!.pointsReward} Points', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (isCorrect) {
                  await _fraudService.markChallengeCompleted(_activeChallenge!.id);
                  await _userService.addPoints(_activeChallenge!.pointsReward);
                  await _loadChallenges();
                }
                setState(() {
                  _activeChallenge = null;
                  _selectedOption = null;
                  _showResult = false;
                });
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: theme.colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
