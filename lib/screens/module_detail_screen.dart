import 'package:flutter/material.dart';
import 'package:mintworth/models/learning_module.dart';
import 'package:mintworth/services/learning_service.dart';
import 'package:mintworth/services/user_service.dart';

class ModuleDetailScreen extends StatefulWidget {
  final LearningModule module;

  const ModuleDetailScreen({super.key, required this.module});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  final _learningService = LearningService();
  final _userService = UserService();
  bool _showQuiz = false;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  int _score = 0;
  bool _quizCompleted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.module.title, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: _showQuiz ? _buildQuizView(theme) : _buildContentView(theme),
    );
  }

  Widget _buildContentView(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: Icon(widget.module.isCompleted ? Icons.check_circle : Icons.school, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.module.category, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(widget.module.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Lesson Content', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
            child: Text(widget.module.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
          ),
          const SizedBox(height: 24),
          if (!widget.module.isCompleted && widget.module.quiz.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _showQuiz = true),
                icon: const Icon(Icons.quiz),
                label: const Text('Take Quiz'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (widget.module.isCompleted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.colorScheme.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.colorScheme.secondary)),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: theme.colorScheme.secondary),
                  const SizedBox(width: 12),
                  Text('Module Completed!', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuizView(ThemeData theme) {
    if (_quizCompleted) return _buildQuizResults(theme);

    final question = widget.module.quiz[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: (_currentQuestionIndex + 1) / widget.module.quiz.length, minHeight: 8, borderRadius: BorderRadius.circular(4)),
          const SizedBox(height: 24),
          Text('Question ${_currentQuestionIndex + 1} of ${widget.module.quiz.length}', style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 16),
          Text(question.question, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          ...List.generate(question.options.length, (index) {
            return GestureDetector(
              onTap: () => setState(() => _selectedAnswer = index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedAnswer == index ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.cardColor,
                  border: Border.all(color: _selectedAnswer == index ? theme.colorScheme.primary : Colors.grey.withValues(alpha: 0.3), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _selectedAnswer == index ? theme.colorScheme.primary : Colors.grey, width: 2), color: _selectedAnswer == index ? theme.colorScheme.primary : Colors.transparent),
                      child: _selectedAnswer == index ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(question.options[index], style: theme.textTheme.bodyLarge)),
                  ],
                ),
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAnswer == null ? null : _handleNextQuestion,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(_currentQuestionIndex < widget.module.quiz.length - 1 ? 'Next Question' : 'Submit Quiz'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResults(ThemeData theme) {
    final passed = _score >= widget.module.quiz.length * 0.5;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: passed ? theme.colorScheme.secondary.withValues(alpha: 0.1) : theme.colorScheme.error.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(passed ? Icons.emoji_events : Icons.refresh, size: 80, color: passed ? theme.colorScheme.secondary : theme.colorScheme.error),
            ),
            const SizedBox(height: 32),
            Text(passed ? 'Congratulations!' : 'Keep Learning!', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('You scored $_score out of ${widget.module.quiz.length}', style: theme.textTheme.titleMedium),
            const SizedBox(height: 32),
            if (passed) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Text('+${widget.module.pointsReward} Points', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (passed) {
                    await _learningService.markModuleCompleted(widget.module.id);
                    await _userService.addPoints(widget.module.pointsReward);
                  }
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16), backgroundColor: theme.colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text(passed ? 'Complete Module' : 'Back to Content'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextQuestion() {
    if (_selectedAnswer == widget.module.quiz[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex < widget.module.quiz.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      setState(() => _quizCompleted = true);
    }
  }
}
